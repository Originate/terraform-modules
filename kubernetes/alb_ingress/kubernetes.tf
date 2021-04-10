data "aws_route53_zone" "base" {
  zone_id = var.route53_zone_id
}

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
          type = "redirect"
          redirectConfig = {
            protocol   = "HTTPS"
            port       = "443"
            statusCode = "HTTP_301"
          }
        }
      )
      "alb.ingress.kubernetes.io/actions.response-404" = jsonencode(
        {
          type = "fixed-response"
          fixedResponseConfig = {
            # contentType = "text/plain"
            statusCode = "404"
            # messageBody = ""
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
      }
    }

    dynamic "rule" {
      for_each = var.ingress_rules

      content {
        host = "${rule.key != "" ? "${rule.key}." : ""}${data.aws_route53_zone.base.name}"

        http {
          dynamic "path" {
            for_each = try(coalescelist(rule.value.disable_paths), [])

            content {
              path = path.value

              backend {
                service_name = "response-404"
                service_port = "use-annotation"
              }
            }
          }

          dynamic "path" {
            for_each = rule.value.paths

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
  }

  wait_for_load_balancer = true
}
