data "aws_caller_identity" "current" {}

# Assumable IAM role that enables login to the cluster
resource "aws_iam_role" "admin" {
  name = "${local.cluster_name}-admin"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )

  tags = var.default_tags
}

resource "aws_iam_role_policy" "admin" {
  name = "eks-auth"
  role = aws_iam_role.admin.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = "eks:DescribeCluster"
          Resource = [
            module.eks.cluster_arn
          ]
        }
      ]
    }
  )
}
