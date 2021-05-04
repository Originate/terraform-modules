resource "aws_iam_role" "opsworks" {
  name = "${local.name}-opsworks-service"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "opsworks.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "opsworks" {
  name = "opsworks-service-permissions"
  role = aws_iam_role.opsworks.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ec2:*",
            "iam:PassRole",
            "cloudwatch:*",
            "elasticloadbalancing:*",
            "iam:GetRolePolicy",
            "iam:ListInstanceProfiles",
            "iam:ListRoles",
            "iam:ListUsers",
            "opsworks:*"
          ]
          Resource = [
            "*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role" "instance" {
  name = "${local.name}-instance"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_instance_profile" "this" {
  name = local.name
  role = aws_iam_role.instance.name
}
