variable "stack" {
  description = "The name of the stack"
  type        = string
}

variable "env" {
  description = "The name of the environment"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to place the bastion host instance"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks allowed SSH access to the bastion host"
  type        = list(string)
}

variable "additional_security_group_ids" {
  description = "A list of additional security groups to attach to the bastion host instance"
  type        = list(string)
  default     = []
}
