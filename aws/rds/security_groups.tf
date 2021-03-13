resource "aws_security_group" "rds" {
  name        = "${local.instance_name}-rds"
  description = "Security group for ${var.sql_database}"
  vpc_id      = var.attributes.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.attributes.allowed_security_group_ids
  }

  tags = {
    Terraform   = "true"
    Stack       = var.attributes.stack
    Environment = var.attributes.env
    Name        = "${local.instance_name}-rds"
  }
}
