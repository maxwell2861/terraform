#---------------------------------------------------------------------
# Provider Setting
#---------------------------------------------------------------------
provider "aws" {
  version = "~> 3.3.0"
  region  = "ap-northeast-2"
}

terraform {
  required_version = ">= 0.14"
  backend "s3" {
    bucket = "test-infraops-conf"
    region = "ap-northeast-2"
    key    = "terraform/test/tfstate/infra/eks/terraform.tfstate"
  }
}

#----------------------------------------------------------------------------------------------
# Load Remote state [Common] 
#----------------------------------------------------------------------------------------------
#Common
data "terraform_remote_state" "common" {
  backend = "s3"
  config ={
    bucket = "test-infraops-conf"
    region = "ap-northeast-2"
    key    = "terraform/test/tfstate/infra/eks/terraform.tfstate"
  }
}



