variable "stack" {
  description = "The name of the stack"
  type        = string
}

variable "env" {
  description = "The name of the environment"
  type        = string
}

variable "kubernetes_namespace" {
  description = "The namespace to deploy into"
  type        = string
}

variable "service_name" {
  description = "The name of the service using this Service Account (used for Service Account and IAM role naming)"
  type        = string
}

variable "eks_oidc_provider_arn" {
  description = "The ARN of the EKS cluster OIDC provider"
  type        = string
}

variable "eks_oidc_issuer_url" {
  description = "The URL of the EKS cluster OIDC issuer"
  type        = string
}

variable "inline_iam_policy_documents" {
  description = "A map of IAM policy documents to apply to the Service Account, with the name of the policy as the key"
  type        = map(string)
  default     = {}
}

variable "attached_iam_policy_arns" {
  description = "A list of IAM policy ARNs to attach to the Service Account"
  type        = list(string)
  default     = []
}
