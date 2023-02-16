resource "aws_route53_zone" "this" {
  name = var.fqdn

  force_destroy = false
}

resource "aws_route53_record" "cloudfront_alias" {
  zone_id = aws_route53_zone.this.id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}
