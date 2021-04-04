resource "aws_kms_key" "tfstate" {
  description             = "Key that encrypts objects in the Terraform backend bucket"
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  is_enabled              = true
  enable_key_rotation     = true

  tags = var.default_tags
}

resource "aws_kms_alias" "tfstate" {
  name          = "alias/s3/${aws_s3_bucket.tfstate.id}"
  target_key_id = aws_kms_key.tfstate.key_id
}
