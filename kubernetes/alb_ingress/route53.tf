data "aws_lb" "ingress" {
  # AWS ELB URL format is <name>-<random_digits>.us-east-1.elb.amazonaws.com
  # e.g. my-loadbalancer-1234567890.us-east-1.elb.amazonaws.com
  name = regex("^([^.]*)(?:-[^.]*)", kubernetes_ingress.public.status[0].load_balancer[0].ingress[0].hostname)[0]
}

resource "aws_route53_record" "ingress" {
  type    = "A"
  name    = ""
  zone_id = var.route53_zone_id

  alias {
    name                   = data.aws_lb.ingress.dns_name
    zone_id                = data.aws_lb.ingress.zone_id
    evaluate_target_health = true
  }
}
