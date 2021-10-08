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
  create_user_messaging = defaults(var.create_user_messaging, {
    email_subject = "Your temporary password"
    email_message = <<-EOT
      Your username is {username} and temporary password is
      <strong>{####}</strong>
    EOT
    sms_message   = <<-EOT
      Your username is {username} and temporary password is
      <strong>{####}</strong>
    EOT
  })
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
    allow_admin_create_user_only = var.allow_admin_create_user_only

    invite_message_template {
      email_subject = local.create_user_messaging.email_subject
      email_message = local.create_user_messaging.email_message
      sms_message   = local.create_user_messaging.sms_message
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

  dynamic "email_configuration" {
    for_each = length(compact(values(var.email_config))) > 0 ? [var.email_config] : []

    content {
      configuration_set      = email_configuration.value.configuration_set
      email_sending_account  = email_configuration.value.email_sending_account
      from_email_address     = email_configuration.value.from_email_address
      reply_to_email_address = email_configuration.value.reply_to_email_address
      source_arn             = email_configuration.value.source_arn
    }
  }

  dynamic "lambda_config" {
    for_each = length(compact(values(var.lambda_config))) > 0 ? [var.lambda_config] : []

    content {
      create_auth_challenge          = lambda_config.value.create_auth_challenge
      custom_message                 = lambda_config.value.custom_message
      define_auth_challenge          = lambda_config.value.define_auth_challenge
      post_authentication            = lambda_config.value.post_authentication
      post_confirmation              = lambda_config.value.post_confirmation
      pre_authentication             = lambda_config.value.pre_authentication
      pre_sign_up                    = lambda_config.value.pre_sign_up
      pre_token_generation           = lambda_config.value.pre_token_generation
      user_migration                 = lambda_config.value.user_migration
      verify_auth_challenge_response = lambda_config.value.verify_auth_challenge_response
      kms_key_id                     = lambda_config.value.kms_key_id
    }
  }

  # This is based on
  # https://github.com/lgallard/terraform-aws-cognito-user-pool/blob/master/main.tf
  #
  # Note that this implementation will work for configuring boolean and datetime
  # attributes, but will not work for string or number attributes because those
  # require constraint configurations in the form of additional nested dynamic
  # blocks.
  dynamic "schema" {
    for_each = var.schemas
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute")
      mutable                  = lookup(schema.value, "mutable")
      name                     = lookup(schema.value, "name")
      required                 = lookup(schema.value, "required")
    }
  }
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
