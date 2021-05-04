data "aws_route53_zone" "base" {
  name = var.base_domain
}

resource "aws_route53_zone" "environment" {
  name = "${var.env}.${data.aws_route53_zone.base.name}"

  force_destroy = false
}

resource "aws_route53_record" "delegation_ns" {
  type    = "NS"
  name    = aws_route53_zone.environment.name
  zone_id = data.aws_route53_zone.base.zone_id
  ttl     = 300

  records = aws_route53_zone.environment.name_servers
}
