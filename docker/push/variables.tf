variable "repo" {
  description = "The URL of the Docker repository to store images"
  type        = string
}

variable "tag" {
  description = "The tag of the Docker image, which acts as the trigger for pushes"
  type        = string
}

variable "login_command" {
  description = "The shell command to execute to login in the Docker registry"
  type        = string
}

variable "build_updated_images" {
  description = "Locally build and push new images when var.docker_tag has changed"
  type        = bool
}

variable "context_path" {
  description = "The path of the Docker build context used when building updated images"
  type        = string
  default     = null
}

variable "build_args" {
  description = "A map of build args passed to Docker when building updated images"
  type        = map(string)
  default     = {}
}

variable "additional_tags" {
  description = "Additional tags to add to the Docker image and push when var.docker_tag has changed"
  type        = list(string)
  default     = []
}
