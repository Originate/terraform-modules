resource "aws_iam_role" "this" {
  name = "${var.stack}-${var.env}-${var.service_name}-eks-pod"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Federated = var.eks_oidc_provider_arn
          }
          Action = "sts:AssumeRoleWithWebIdentity"
          Condition = {
            StringEquals = {
              "${replace(var.eks_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:${var.kubernetes_namespace}:${local.service_account_name}"
            }
          }
        }
      ]
    }
  )

  tags = var.default_tags
}

resource "aws_iam_role_policy" "this" {
  name = "${var.service_name}-permissions"
  role = aws_iam_role.this.id

  policy = var.iam_policy_document
}
