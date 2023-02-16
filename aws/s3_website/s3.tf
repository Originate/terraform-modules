resource "aws_s3_bucket" "website" {
  bucket = var.fqdn
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = var.index_document
  }

  dynamic "error_document" {
    for_each = var.error_document != "" ? [var.error_document] : []

    content {
      key = error_document.value
    }
  }

  dynamic "routing_rule" {
    for_each = var.error_document == "" ? [403, 404] : []

    content {
      condition {
        http_error_code_returned_equals = routing_rule.value
      }

      redirect {
        host_name        = var.fqdn
        replace_key_with = var.index_document
      }
    }
  }
}

resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_logging" "website" {
  bucket = aws_s3_bucket.website.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "access/"
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.fqdn}-logs"
}

resource "aws_s3_bucket_acl" "logs" {
  bucket = aws_s3_bucket.logs.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "content" {
  for_each = fileset(var.source_dir, "**")

  bucket = aws_s3_bucket.website.id
  key    = each.value
  acl    = "public-read"

  source       = "${var.source_dir}/${each.value}"
  source_hash  = filemd5("${var.source_dir}/${each.value}")
  content_type = lookup(local.file_types, try(regex("\\.[^.]+$", each.value), ""), null)
}
