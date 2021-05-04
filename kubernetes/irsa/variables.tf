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

variable "iam_policy_document" {
  description = "The IAM policy document of permissions to apply to the Service Account"
  type        = string
}
