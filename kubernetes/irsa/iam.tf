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
}

resource "aws_iam_role_policy" "this" {
  for_each = var.inline_iam_policy_documents

  name = each.key
  role = aws_iam_role.this.id

  policy = each.value
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.attached_iam_policy_arns)

  role       = aws_iam_role.this.id
  policy_arn = each.value
}
