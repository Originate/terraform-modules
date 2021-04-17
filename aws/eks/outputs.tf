output "cluster_name" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "admin_iam_role_name" {
  value = aws_iam_role.admin.name
}

output "admin_iam_role_arn" {
  value = aws_iam_role.admin.arn
}
