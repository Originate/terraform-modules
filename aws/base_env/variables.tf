variable "env" {
  description = "The name of the environment"
  type        = string
}

variable "base_domain" {
  description = "The base domain name"
  type        = string
}

variable "use_env_subdomain" {
  description = "Creates the environment hosted zone as a subdomain of an existing hosted zone for the base domain, otherwise creates the environment hosted zone for the base domain directly"
  type        = bool
}
