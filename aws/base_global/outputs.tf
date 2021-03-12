output "domain_name_servers" {
  value = aws_route53_zone.base.name_servers
}

output "ecr_repo_urls" {
  value = {
    for key, repo in aws_ecr_repository.repo :
    key => repo.repository_url
  }
}
