terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2" 
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.0"
    }
    aws = {
      source  = "hashicorp/aws"
    }
  }
}