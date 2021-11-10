output "arn" {
  value = aws_sqs_queue.this.arn
}

output "name" {
  value = aws_sqs_queue.this.name
}

output "url" {
  value = aws_sqs_queue.this.url
}
