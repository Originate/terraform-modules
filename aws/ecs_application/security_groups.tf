resource "aws_security_group" "ecs_tasks" {
  name        = "${var.cluster_name}-${var.name}-ecs-tasks"
  description = "Security group for ${var.name} ECS service in ${var.cluster_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-${var.name}-ecs-tasks"
  }
}
