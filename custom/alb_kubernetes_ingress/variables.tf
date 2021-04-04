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

variable "ingress_path_backends" {
  description = "An ordered list of service endpoints to forward traffic for the given pattern"
  type = list(object({
    pattern      = string
    service_name = string
    service_port = number
  }))
}
