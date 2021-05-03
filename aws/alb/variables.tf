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

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs to attach to the load balancer"
  type        = list(string)
}

variable "route53_zone_id" {
  description = "The ID of the environment Route53 zone"
  type        = string
}

variable "subdomains" {
  description = "A list of subdomains to direct to the ALB (use an empty string for the base domain and '*' for wildcard matching)"
  type        = list(string)
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "ingress_rules" {
  description = "A map of hosts to forward or disable traffic for the list of given path patterns, with the subdomain as the key (or empty string for the base domain)"
  type = map(object(
    {
      paths = list(object(
        {
          pattern          = string
          target_group_arn = string
        }
      ))
      disable_paths = optional(list(string))
    }
  ))
}
