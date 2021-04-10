output "domain_name_servers" {
  value = aws_route53_zone.base.name_servers
}

output "ecr_repository_urls" {
  value = {
    for key, repo in module.ecr :
    key => repo.repository_url
  }
}
