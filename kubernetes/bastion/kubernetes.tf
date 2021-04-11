locals {
  name = "bastion"
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = local.name
  }
}

resource "kubernetes_secret" "ssh_key" {
  metadata {
    name      = "${local.name}-ssh-key"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  type = "Opaque"

  data = {
    private_key_pem = tls_private_key.ssh.private_key_pem
  }
}

resource "kubernetes_deployment" "this" {
  metadata {
    name      = local.name
    namespace = kubernetes_namespace.this.metadata[0].name

    labels = {
      app = local.name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = local.name
      }
    }

    template {
      metadata {
        labels = {
          app = local.name
        }

        annotations = {
          "seccomp.security.alpha.kubernetes.io/pod" = "runtime/default"
        }
      }

      spec {
        container {
          name  = local.name
          image = "${var.docker_repo}:${local.docker_tag}"

          port {
            container_port = var.ssh_port
          }

          security_context {
            capabilities {
              drop = ["all"]

              # These capabilities are needed so OpenSSH can do privilege
              # separation to ensure that SSH users don't have the same
              # privileges as the OpenSSH server
              add = ["SYS_CHROOT", "SETGID", "SETUID", "CHOWN"]
            }

            allow_privilege_escalation = false
            privileged                 = false
            read_only_root_filesystem  = true

            # The container runs as root because the OpenSSH server has to run
            # as root. To mitigate any potential risk, SSH login as root is
            # disabled.
            run_as_non_root = false
            run_as_user     = 0
          }

          volume_mount {
            mount_path = "/var/run"
            name       = "pid"
          }
        }

        volume {
          name = "pid"
          empty_dir {
            medium = "Memory"
          }
        }
      }
    }
  }

  depends_on = [module.docker_push]

  timeouts {
    create = "5m"
    update = "5m"
  }
}
