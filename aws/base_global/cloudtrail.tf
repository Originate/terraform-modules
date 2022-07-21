resource "aws_s3_bucket" "cloudtrail" {
  bucket = "${var.stack}-cloudtrail-logs"
}

resource "aws_s3_bucket_acl" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "AclCheck"
          Effect = "Allow"
          Principal = {
            Service = "cloudtrail.amazonaws.com"
          }
          Action   = "s3:GetBucketAcl"
          Resource = aws_s3_bucket.cloudtrail.arn
        },
        {
          Sid    = "LogsWrite"
          Effect = "Allow"
          Principal = {
            Service = "cloudtrail.amazonaws.com"
          }
          Action   = "s3:PutObject"
          Resource = "${aws_s3_bucket.cloudtrail.arn}/*"
          Condition = {
            StringEquals = {
              "s3:x-amz-acl" = "bucket-owner-full-control"
            }
          }
        }
      ]
    }
  )

  # Avoids issues when Terraform tries to update the public access settings and
  # bucket policy simultaneously
  depends_on = [
    aws_s3_bucket_public_access_block.cloudtrail
  ]
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name = "${var.stack}-cloudtrail-logs"
}

resource "aws_iam_role" "cloudtrail" {
  name = "${var.stack}-cloudtrail"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "cloudtrail.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "cloudtrail" {
  name = "cloudwatch-permissions"
  role = aws_iam_role.cloudtrail.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = [
            "${aws_cloudwatch_log_group.cloudtrail.arn}:log-stream:*"
          ]
        }
      ]
    }
  )
}

resource "aws_cloudtrail" "this" {
  name = "${var.stack}-events"

  s3_bucket_name = aws_s3_bucket.cloudtrail.id

  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail.arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"

  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = false
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  # AWS checks that CloudTrail has access to write to the S3 bucket so this
  # fails if the bucket policy is not in place first
  depends_on = [
    aws_s3_bucket_policy.cloudtrail
  ]
}
