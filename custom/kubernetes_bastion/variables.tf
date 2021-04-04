variable "ssh_port" {
  description = "The port number to use for SSH"
  type        = number

  validation {
    condition     = var.ssh_port >= 1025 && var.ssh_port <= 65535
    error_message = "The ssh_port value must be between 1025 and 65535, inclusive."
  }
}

variable "repo_url" {
  description = "The URL of the Docker repository to store images"
  type        = string
}

variable "docker_login_command" {
  description = "The shell command to execute to login in the Docker registry"
  type        = string
}
