variable "stack" {
  description = "The name of the stack"
  type        = string
}

variable "env" {
  description = "The environment name to use with AWS tags"
  type        = string
}

variable "domain" {
  description = "The base domain name for the stack"
  type        = string
}

variable "repo_names" {
  description = "A list of the ECR repository names"
  type        = list(string)
}
