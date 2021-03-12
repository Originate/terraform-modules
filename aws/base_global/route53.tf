resource "aws_route53_zone" "base" {
  name = var.domain

  force_destroy = false

  tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = var.env
  }
}
