variable "name" {
  description = "The name of this service"
  type        = string
}

variable "kubernetes_namespace" {
  description = "The namespace to deploy into"
  type        = string
}

variable "docker_repo" {
  description = "The repository of the Docker image to deploy"
  type        = string
}

variable "docker_tag" {
  description = "The tag of the Docker image to deploy"
  type        = string
}

variable "container_port" {
  description = "The port that the container is listening"
  type        = number

  validation {
    condition     = var.container_port >= 1025 && var.container_port <= 65535
    error_message = "The container_port value must be between 1025 and 65535, inclusive."
  }
}

variable "health_check_path" {
  description = "The URL path of the health check endpoint (e.g. '/healthcheck')"
  type        = string
}

variable "config_maps" {
  description = "Kubernetes ConfigMaps passed into Pods as environment variables"
  type        = map(map(string))
  default     = {}
}

variable "secrets" {
  description = "Kubernetes Secrets passed into Pods as environment variables"
  type        = map(map(string))
  default     = {}
}

# Containers are run with read-only root filesystems. Use this to provide
# applications with a tmpfs volume that they are able to write to if needed.
variable "ephemeral_mount_paths" {
  description = "A map directory paths for mounting ephemeral (tmpfs) volumes on the containers"
  type        = map(string)
  default     = {}
}

variable "autoscale_max" {
  description = "Maximum number of instances per service"
  type        = number
}

variable "autoscale_min" {
  description = "Minimum number of instances per service"
  type        = number
}

variable "using_eks" {
  description = "Set to true for running on EKS clusters"
  type        = bool
  default     = false
}
