terraform {
  required_version = ">= 0.13"
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 1.13.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 1.3.2"
    }
    null = ">= 2.1"
  }
}

