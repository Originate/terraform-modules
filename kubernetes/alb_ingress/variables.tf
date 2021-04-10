variable "default_tags" {
  description = "Default tags to add to AWS resources"
  type        = map(string)
}

variable "kubernetes_namespace" {
  description = "The namespace to deploy into"
  type        = string
}

variable "route53_zone_id" {
  description = "The ID of the environment Route53 zone"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of the environment's ACM certificate"
  type        = string
}

variable "ingress_rules" {
  description = "A map of hosts to forward or disable traffic for the list of given path patterns, with the subdomain as the key (or empty string for the base domain)"
  type = map(object(
    {
      paths = list(object(
        {
          pattern      = string
          service_name = string
          service_port = number
        }
      ))
      disable_paths = optional(list(string))
    }
  ))
}
