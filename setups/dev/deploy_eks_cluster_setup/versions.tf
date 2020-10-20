terraform {
  required_version = ">= 0.13"
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 1.11.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 1.3.2"
    }
    null = ">= 2.1"
    aws  = ">= 2.28.1"
  }
}

