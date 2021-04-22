variable "name" {
  description = "The name of this job"
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

variable "docker_cmd" {
  description = "Overrides the default CMD of the Docker image"
  type        = list(string)
  default     = null
}

variable "docker_entrypoint" {
  description = "Overrides the default ENTRYPOINT of the Docker image"
  type        = list(string)
  default     = null
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

variable "service_account_name" {
  description = "The name of an existing Kubernetes Service Account to associate with Pods (leave blank to not associate a Service Account)"
  type        = string
  default     = null
}

# Containers are run with read-only root filesystems. Use this to provide
# applications with a tmpfs volume that they are able to write to if needed.
variable "ephemeral_mount_paths" {
  description = "A map directory paths for mounting ephemeral (tmpfs) volumes on the containers"
  type        = map(string)
  default     = {}
}

variable "run_as_user" {
  description = "The Linux user ID to run the container"
  type        = number
  default     = 65534 # nobody

  validation {
    condition     = var.run_as_user >= 0 && var.run_as_user <= 65534
    error_message = "The run_as_user value must be between 0 and 65534, inclusive."
  }
}

variable "run_as_group" {
  description = "The Linux group ID to run the container"
  type        = number
  default     = 65534 # nogroup

  validation {
    condition     = var.run_as_group >= 0 && var.run_as_group <= 65534
    error_message = "The run_as_group value must be between 0 and 65534, inclusive."
  }
}
