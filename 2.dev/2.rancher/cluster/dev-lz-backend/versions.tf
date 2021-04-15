

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
      local.cluster_info["cluster_name"]
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
    key    = "terraform/test/tfstate/dev/k8s/dev-test-backend/project/terraform.tfstate"
  }
}

#---------------------------------------------------
# Get ACM / Network Resource
#---------------------------------------------------
data "terraform_remote_state" "acm" {
  backend = "s3"
  config ={
    bucket = "test-devops-conf"
    region = "ap-northeast-2"
    key    = "terraform/test/tfstate/common/terraform.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config ={
    bucket = "test-devops-conf"
    region = "ap-northeast-2"
    key    = "terraform/test/tfstate/dev/eks/terraform.tfstate"
  }
}
