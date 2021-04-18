terraform {
  required_version = ">= 0.15"

  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}
