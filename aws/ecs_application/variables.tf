variable "default_tags" {
  description = "Default tags to add to AWS resources"
  type        = map(string)
}

variable "name" {
  description = "The name of this service"
  type        = string
}

variable "cluster_name" {
  description = "The name of the ECS cluster where the service should run"
  type        = string
}

variable "cluster_arn" {
  description = "The ARN of the ECS cluster where the service should run"
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

variable "environment_variables" {
  description = "A map of environment variables to set on the container"
  type        = map(string)
  default     = {}
}

variable "environment_secrets_arns" {
  description = "A map of secrets passed into the container as environment variables, where the key is the environment variable name and the value is the ARN of the SSM parameter or Secrets Manager secret"
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

variable "desired_count" {
  description = "The desired number of instances per service"
  type        = number
}

variable "cpu" {
  description = "The hard limit of CPU units to present for the task (for available options, see https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
  type        = number
}

variable "memory" {
  description = "The hard limit of memory (in MiB) to present to the task (for available options, see https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
  type        = number
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs to place ECS tasks"
  type        = list(string)
}

variable "task_execution_role_arn" {
  description = "The ARN of the ECS task execution IAM role"
  type        = string
}

variable "iam_policy_document" {
  description = "The IAM policy document of permissions to apply to ECS tasks, or leave blank to not assign any permissions"
  type        = string
  default     = ""
}

variable "allowed_security_group_ids" {
  description = "A list of security group IDs that are allowed to access the service"
  type        = list(string)
}

variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group to write log streams"
  type        = string
}
