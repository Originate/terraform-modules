output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "security_group_id" {
  value = aws_security_group.ecs_tasks.id
}
