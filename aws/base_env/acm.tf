resource "aws_acm_certificate" "environment" {
  domain_name       = aws_route53_zone.environment.name
  validation_method = "DNS"

  tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = var.env
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.environment.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name            = each.value.name
  type            = each.value.type
  zone_id         = aws_route53_zone.environment.zone_id
  ttl             = 60
  allow_overwrite = true

  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "environment" {
  certificate_arn = aws_acm_certificate.environment.arn

  validation_record_fqdns = [for record in aws_route53_record.acm_certificate_validation : record.fqdn]
}
