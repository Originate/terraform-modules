resource "aws_kms_key" "secrets" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  is_enabled              = true
  enable_key_rotation     = true

  tags = var.default_tags
}

resource "aws_kms_alias" "secrets" {
  name          = "alias/eks/${local.cluster_name}-secrets"
  target_key_id = aws_kms_key.secrets.key_id
}
