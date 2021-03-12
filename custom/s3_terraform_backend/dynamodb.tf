resource "aws_dynamodb_table" "terraform_lock" {
  name         = "TerraformLock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = var.env
  }
}
