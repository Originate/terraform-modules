variable "env" {
  description = "The name of the environment"
  type        = string
}

variable "default_tags" {
  description = "Default tags to add to AWS resources"
  type        = map(string)
}

variable "base_domain" {
  description = "The base domain name for the stack"
  type        = string
}
