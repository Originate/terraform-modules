resource "aws_lb_target_group" "this" {
  name        = "${var.cluster_name}-${var.name}"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled  = true
    protocol = "HTTP"
    path     = var.health_check_path
    port     = "traffic-port"
    matcher  = 200

    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
  }
}
