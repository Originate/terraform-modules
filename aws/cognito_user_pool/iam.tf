resource "random_uuid" "external_id" {}

resource "aws_iam_role" "this" {
  name = "${var.stack}-${var.env}-${var.identifier}-cognito-user-pool"

  assume_role_policy = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "cognito-idp.amazonaws.com"
          },
          "Action": "sts:AssumeRole",
          "Condition": {
            "StringEquals": {
              "sts:ExternalId": "${random_uuid.external_id.result}"
            }
          }
        }
      ]
    }
  EOT

  tags = var.default_tags
}

resource "aws_iam_role_policy" "this" {
  name = "sns-permissions"
  role = aws_iam_role.this.id

  policy = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "sns:publish",
          "Resource": [
            "*"
          ]
        }
      ]
    }
  EOT
}
