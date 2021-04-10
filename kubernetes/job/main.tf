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

resource "kubernetes_job" "this" {
  metadata {
    name      = "${var.name}-${var.docker_tag}"
    namespace = var.kubernetes_namespace

    labels = {
      app       = var.name
      image_tag = var.docker_tag
    }
  }

  spec {
    template {
      metadata {
        labels = {
          app       = var.name
          image_tag = var.docker_tag
        }

        annotations = {
          "seccomp.security.alpha.kubernetes.io/pod" = "runtime/default"
        }
      }

      spec {
        container {
          name  = var.name
          image = "${var.docker_repo}:${var.docker_tag}"

          args    = var.docker_cmd
          command = var.docker_entrypoint

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

          security_context {
            capabilities {
              drop = ["all"]
            }

            allow_privilege_escalation = false
            privileged                 = false
            read_only_root_filesystem  = true
            run_as_non_root            = true
            run_as_user                = var.run_as_user
            run_as_group               = var.run_as_group
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

        restart_policy = "Never"
      }
    }

    completions = 1
    parallelism = 1
  }

  wait_for_completion = true

  timeouts {
    create = "5m"
    update = "5m"
  }
}
