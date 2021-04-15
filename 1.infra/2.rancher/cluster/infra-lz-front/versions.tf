

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      local.k8s_cluster_name
    ]
  }
}

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

  required_version = ">= 0.14" 
  backend "s3" {
    bucket = "test-devops-conf"
    region = "ap-northeast-2"
    key    = "terraform/test/tfstate/infra/rancher/infra-test-front/project/terraform.tfstate"
  }
}

