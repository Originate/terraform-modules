locals {
  alb_name = "${var.stack}-${var.env}-alb"
  listener_rules = flatten(
    [
      for host, rules in { for subdomain, rules in var.ingress_rules : "${subdomain != "" ? "${subdomain}." : ""}${data.aws_route53_zone.base.name}" => rules } :
      concat(
        [
          for path in rules.disable_paths == null ? [] : rules.disable_paths :
          {
            host_header      = host
            path_pattern     = path
            target_group_arn = null
          }
        ],
        [
          for path in rules.paths :
          {
            host_header      = host
            path_pattern     = path.pattern
            target_group_arn = path.target_group_arn
          }
        ]
      )
    ]
  )
}

data "aws_route53_zone" "base" {
  zone_id = var.route53_zone_id
}

resource "aws_lb" "this" {
  name               = local.alb_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = var.subnet_ids
  enable_http2       = true
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      port        = 443
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  protocol          = "HTTPS"
  port              = 443
  certificate_arn   = var.acm_certificate_arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "https" {
  for_each = { for i, rule in local.listener_rules : (i + 1) => rule }

  listener_arn = aws_lb_listener.https.arn
  priority     = each.key

  action {
    type             = each.value.target_group_arn == null ? "fixed-response" : "forward"
    target_group_arn = each.value.target_group_arn

    dynamic "fixed_response" {
      for_each = each.value.target_group_arn == null ? [true] : []

      content {
        content_type = "text/plain"
        status_code  = 404
      }
    }
  }

  condition {
    host_header {
      values = [each.value.host_header]
    }
  }

  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }
}
