resource "kubernetes_ingress" "public" {
  metadata {
    name      = "public-ingress"
    namespace = var.kubernetes_namespace

    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/tags"            = join(",", [for k, v in merge(var.default_tags, { Terraform = "false" }) : "${k}=${v}"])
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/certificate-arn" = var.acm_certificate_arn
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode(
        [
          {
            HTTP = 80
          },
          {
            HTTPS = 443
          }
        ]
      )
      "alb.ingress.kubernetes.io/actions.ssl-redirect" = jsonencode(
        {
          Type = "redirect"
          RedirectConfig = {
            Protocol   = "HTTPS"
            Port       = "443"
            StatusCode = "HTTP_301"
          }
        }
      )
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/*"

          backend {
            service_name = "ssl-redirect"
            service_port = "use-annotation"
          }
        }

        dynamic "path" {
          for_each = var.ingress_path_backends

          content {
            path = path.value.pattern

            backend {
              service_name = path.value.service_name
              service_port = path.value.service_port
            }
          }
        }
      }
    }
  }

  wait_for_load_balancer = true
}
