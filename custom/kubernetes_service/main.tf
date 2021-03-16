resource "kubernetes_config_map" "this" {
  for_each = var.config_maps

  metadata {
    name      = "${var.name}-${each.key}"
    namespace = var.kubernetes_namespace
  }

  data = each.value
}

resource "kubernetes_secret" "this" {
  for_each = var.secrets

  metadata {
    name      = "${var.name}-${each.key}"
    namespace = var.kubernetes_namespace
  }

  type = "Opaque"

  data = each.value
}

resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.name
    namespace = var.kubernetes_namespace

    labels = {
      app = var.name
    }
  }

  spec {
    replicas = var.autoscale_min

    selector {
      match_labels = {
        app = var.name
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = "100%"
        max_unavailable = "25%"
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }

        annotations = {
          "seccomp.security.alpha.kubernetes.io/pod" = "runtime/default"
        }
      }

      spec {
        container {
          name  = var.name
          image = "${var.docker_repo}:${var.docker_tag}"

          dynamic "env_from" {
            for_each = kubernetes_config_map.this

            content {
              config_map_ref {
                name = env_from.value.metadata[0].name
              }
            }
          }

          dynamic "env_from" {
            for_each = kubernetes_secret.this

            content {
              secret_ref {
                name = env_from.value.metadata[0].name
              }
            }
          }

          port {
            container_port = var.container_port
          }

          security_context {
            capabilities {
              drop = ["all"]
            }

            allow_privilege_escalation = false
            privileged                 = false
            read_only_root_filesystem  = true
            run_as_non_root            = true
            run_as_user                = 65534 # nobody
            run_as_group               = 65534 # nogroup
          }

          liveness_probe {
            tcp_socket {
              port = var.container_port
            }

            failure_threshold     = 2
            initial_delay_seconds = 30
            period_seconds        = 30
            success_threshold     = 1
            timeout_seconds       = 2
          }

          readiness_probe {
            http_get {
              path = var.health_check_path
              port = var.container_port
            }

            failure_threshold     = 2
            initial_delay_seconds = 30
            period_seconds        = 30
            success_threshold     = 1
            timeout_seconds       = 2
          }

          dynamic "volume_mount" {
            for_each = var.ephemeral_mount_paths

            content {
              name       = volume_mount.key
              mount_path = volume_mount.value
            }
          }
        }

        dynamic "volume" {
          for_each = var.ephemeral_mount_paths

          content {
            name = volume.key

            empty_dir {
              medium = "Memory"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "this" {
  metadata {
    name      = kubernetes_deployment.this.metadata[0].name
    namespace = kubernetes_deployment.this.metadata[0].namespace
  }

  spec {
    min_replicas = var.autoscale_min
    max_replicas = var.autoscale_max

    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.this.metadata[0].name
    }
  }
}

resource "kubernetes_service" "this" {
  metadata {
    name      = kubernetes_deployment.this.metadata[0].name
    namespace = kubernetes_deployment.this.metadata[0].namespace

    annotations = var.using_eks ? {
      "alb.ingress.kubernetes.io/healthcheck-path" = var.health_check_path
    } : null
  }

  spec {
    selector = {
      app = kubernetes_deployment.this.spec[0].template[0].metadata[0].labels.app
    }

    type = var.using_eks ? "NodePort" : "ClusterIP"

    port {
      name        = "http"
      port        = 80
      target_port = kubernetes_deployment.this.spec[0].template[0].spec[0].container[0].port[0].container_port
    }
  }
}
