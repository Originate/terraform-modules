locals {
  pool_name = "${var.stack}-${var.env}-${var.identifier}"
  writable_user_attributes = [
    "address",
    "birthdate",
    "email",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo"
  ]
  readable_user_attributes = concat(local.writable_user_attributes, [
    "email_verified",
    "phone_number_verified"
  ])
}

resource "aws_cognito_user_pool" "this" {
  name = local.pool_name

  mfa_configuration          = "OPTIONAL"
  username_attributes        = ["email"]
  auto_verified_attributes   = ["email"]
  sms_authentication_message = "Your authentication code is {####}"

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false

    invite_message_template {
      email_subject = "Your temporary password"
      email_message = <<-EOT
        Your username is {username} and temporary password is
        <strong>{####}</strong>
      EOT
      sms_message   = <<-EOT
        Your username is {username} and temporary password is
        <strong>{####}</strong>
      EOT
    }
  }

  password_policy {
    minimum_length                   = var.password_policy.min_length
    require_lowercase                = var.password_policy.require_lowercase
    require_numbers                  = var.password_policy.require_numbers
    require_symbols                  = var.password_policy.require_symbols
    require_uppercase                = var.password_policy.require_uppercase
    temporary_password_validity_days = 7
  }

  sms_configuration {
    external_id    = random_uuid.external_id.result
    sns_caller_arn = aws_iam_role.this.arn
  }

  software_token_mfa_configuration {
    enabled = true
  }

  username_configuration {
    case_sensitive = false
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Your verification code"
    email_message        = <<-EOT
      Your verification code is
      <strong>{####}</strong>
    EOT
  }

  tags = var.default_tags
}

resource "aws_cognito_user_pool_client" "this" {
  for_each = var.clients

  name         = each.value.name
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret               = false
  prevent_user_existence_errors = "ENABLED"
  read_attributes               = local.readable_user_attributes
  write_attributes              = local.writable_user_attributes
}

resource "aws_cognito_user_group" "this" {
  for_each = var.groups

  name         = each.value.name
  user_pool_id = aws_cognito_user_pool.this.id

  description = each.value.description
  precedence  = each.value.precedence
}
