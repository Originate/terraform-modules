variable "stack" {
  description = "The name of the stack"
  type        = string
}

variable "env" {
  description = "The name of the environment"
  type        = string
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The list of IDs to place the EKS cluster and workers"
  type        = list(string)
}

variable "node_instance_class" {
  description = "The EC2 instance class type of the nodes"
  type        = string
}

variable "node_disk_size" {
  description = "The disk size of the nodes"
  type        = number
}

variable "node_count_min" {
  description = "The minimum number of nodes"
  type        = number
}

variable "node_count_max" {
  description = "The maximum number of nodes"
  type        = number
}

variable "kms_key_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource"
  type        = number

  validation {
    condition     = var.kms_key_deletion_window_in_days >= 7 && var.kms_key_deletion_window_in_days <= 30
    error_message = "The kms_key_deletion_window_in_days value must be between 7 and 30 days, inclusive."
  }
}

variable "aws_load_balancer_controller_version" {
  description = "Version of the AWS Load Balancer Controller to run"
  type        = string
}
