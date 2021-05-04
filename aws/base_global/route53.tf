resource "aws_route53_zone" "base" {
  name = var.domain

  force_destroy = false
}
