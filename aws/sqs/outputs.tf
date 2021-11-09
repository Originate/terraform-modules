output "arn" {
  value = aws_sqs_queue.this.arn
}

output "full_queue_name" {
  value = aws_sqs_queue.this.name
}
