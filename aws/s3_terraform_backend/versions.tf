terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}
