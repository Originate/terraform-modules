data "aws_route53_zone" "base" {
  count = var.use_env_subdomain ? 1 : 0

  name = var.base_domain
}

resource "aws_route53_zone" "environment" {
  name = var.use_env_subdomain ? "${var.env}.${data.aws_route53_zone.base[0].name}" : var.base_domain

  force_destroy = false
}

resource "aws_route53_record" "delegation_ns" {
  count = var.use_env_subdomain ? 1 : 0

  type    = "NS"
  name    = aws_route53_zone.environment.name
  zone_id = data.aws_route53_zone.base[0].zone_id
  ttl     = 300

  records = aws_route53_zone.environment.name_servers
}
