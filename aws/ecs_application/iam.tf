resource "aws_iam_role" "this" {
  name = "${var.cluster_name}-${var.name}-task"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )

  tags = var.default_tags
}

resource "aws_iam_role_policy" "this" {
  count = var.iam_policy_document != "" ? 1 : 0

  name = "${var.name}-permissions"
  role = aws_iam_role.this.id

  policy = var.iam_policy_document
}
