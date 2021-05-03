resource "aws_route53_record" "this" {
  for_each = toset(var.subdomains)

  type    = "A"
  name    = each.key
  zone_id = var.route53_zone_id

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
