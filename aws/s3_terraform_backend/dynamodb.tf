resource "aws_dynamodb_table" "terraform_lock" {
  name         = "${var.stack}-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
