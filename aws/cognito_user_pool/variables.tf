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
      create_auth_challenge          = string
      custom_message                 = string
      define_auth_challenge          = string
      post_authentication            = string
      post_confirmation              = string
      pre_authentication             = string
      pre_sign_up                    = string
      pre_token_generation           = string
      user_migration                 = string
      verify_auth_challenge_response = string
      kms_key_id                     = string
    }
  )
  default = {
    create_auth_challenge          = ""
    custom_message                 = ""
    define_auth_challenge          = ""
    post_authentication            = ""
    post_confirmation              = ""
    pre_authentication             = ""
    pre_sign_up                    = ""
    pre_token_generation           = ""
    user_migration                 = ""
    verify_auth_challenge_response = ""
    kms_key_id                     = ""
  }
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
