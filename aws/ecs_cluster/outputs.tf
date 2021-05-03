output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "cluster_arn" {
  value = aws_ecs_cluster.this.arn
}

output "task_execution_role_arn" {
  value = aws_iam_role.task_execution.arn
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.this.name
}

output "secrets_prefix" {
  value = local.secrets_prefix
}

output "secrets_kms_key_id" {
  value = aws_kms_key.secrets.id
}
