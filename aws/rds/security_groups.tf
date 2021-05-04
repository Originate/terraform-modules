resource "aws_security_group" "rds" {
  name        = "${local.instance_name}-rds"
  description = "Security group for ${local.instance_name}"
  vpc_id      = var.attributes.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.attributes.allowed_security_group_ids
  }

  tags = merge(var.attributes.default_tags, {
    Name = "${local.instance_name}-rds"
  })
}
