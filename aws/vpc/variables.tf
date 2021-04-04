variable "stack" {
  description = "The name of the stack"
  type        = string
}

variable "env" {
  description = "The name of the environment"
  type        = string
}

variable "default_tags" {
  description = "Default tags to add to AWS resources"
  type        = map(string)
}

variable "az_count" {
  description = "The number of availability zones to use"
  type        = number
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks to use for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks to use for the private subnets"
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "A list of CIDR blocks to use for the database subnets"
  type        = list(string)
}
