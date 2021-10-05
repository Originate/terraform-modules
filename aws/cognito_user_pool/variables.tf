variable "stack" {
  description = "The name of the stack"
  type        = string
}

variable "env" {
  description = "The name of the environment"
  type        = string
}

variable "identifier" {
  description = "A short identifying name for this user pool"
  type        = string
}

variable "password_policy" {
  description = "The strength requirements for user passwords"
  type = object(
    {
      min_length        = number
      require_lowercase = bool
      require_numbers   = bool
      require_symbols   = bool
      require_uppercase = bool
    }
  )
  default = {
    min_length        = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }
}

variable "lambda_config" {
  description = "Sets which lambda function to use for various cognito specializations"
  type = object(
    {
      create_auth_challenge          = optional(string)
      custom_message                 = optional(string)
      define_auth_challenge          = optional(string)
      post_authentication            = optional(string)
      post_confirmation              = optional(string)
      pre_authentication             = optional(string)
      pre_sign_up                    = optional(string)
      pre_token_generation           = optional(string)
      user_migration                 = optional(string)
      verify_auth_challenge_response = optional(string)
      kms_key_id                     = optional(string)
    }
  )
  default = {}
}

variable "clients" {
  description = "A map of user pool clients to create"
  type = map(object(
    {
      name = string
    }
  ))
  default = {}
}

variable "groups" {
  description = "A map of user groups to create"
  type = map(object(
    {
      name        = string
      description = string
      precedence  = number
    }
  ))
  default = {}
}

variable "create_user_messaging" {
  description = "Provides basic customized messaging for new accounts"
  type = object(
    {
      email_subject = optional(string)
      email_message = optional(string)
      sms_message   = optional(string)
    }
  )
  default = {
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

variable "allow_admin_create_user_only" {
  description = "Indicates if users should not be able to self register. False = User can self register"
  type        = string
  default     = false
}
