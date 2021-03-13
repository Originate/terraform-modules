resource "aws_kms_key" "secrets" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  is_enabled              = true
  enable_key_rotation     = true

  tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = var.env
  }
}

resource "aws_kms_alias" "secrets" {
  name          = "alias/${var.stack}-${var.env}-eks-secrets"
  target_key_id = aws_kms_key.secrets.key_id
}
