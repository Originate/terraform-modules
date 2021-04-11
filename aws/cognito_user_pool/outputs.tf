output "id" {
  value = aws_cognito_user_pool.this.id
}

output "arn" {
  value = aws_cognito_user_pool.this.arn
}

output "endpoint" {
  value = aws_cognito_user_pool.this.endpoint
}

output "client_ids" {
  value = { for key, client in aws_cognito_user_pool_client.this : key => client.id }
}
