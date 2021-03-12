output "region" {
  value = data.aws_region.current.name
}

output "bucket_name" {
  value = aws_s3_bucket.tfstate.id
}

output "bucket_arn" {
  value = aws_s3_bucket.tfstate.arn
}

output "kms_key_id" {
  value = aws_kms_key.tfstate.key_id
}

output "kms_key_arn" {
  value = aws_kms_key.tfstate.arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_lock.name
}

output "profile" {
  value = var.profile
}
