variable "profile" {
  description = "The profile to use for accessing the AWS account"
  type        = string
}

variable "stack" {
  description = "Stack name"
  type        = string
}

variable "env" {
  description = "The name of the environment"
  type        = string
}

variable "ssh_port" {
  description = "The port number to use for SSH"
  type        = number

  validation {
    condition     = var.ssh_port >= 1025 && var.ssh_port <= 65535
    error_message = "The ssh_port value must be between 1025 and 65535, inclusive."
  }
}
