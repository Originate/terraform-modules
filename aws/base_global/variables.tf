variable "stack" {
  description = "The name of the stack"
  type        = string
}

variable "default_tags" {
  description = "Default tags to add to AWS resources"
  type        = map(string)
}

variable "domain" {
  description = "The base domain name for the stack"
  type        = string
}

variable "repo_names" {
  description = "A list of the ECR repository names"
  type        = list(string)
}
