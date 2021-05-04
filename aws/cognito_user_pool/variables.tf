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
