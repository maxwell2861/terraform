#---------------------------------------------------------------------
# Provider Setting
#---------------------------------------------------------------------
provider "aws" {
  region  = "ap-northeast-2"
}

terraform {
  required_version = ">= 0.14"
  backend "s3" {
    bucket = "test-devops-conf"
    region = "ap-northeast-2"
    key    = "terraform/test/tfstate/dev/elasticache/terraform.tfstate"
  }
}

#----------------------------------------------------------------------------------------------
# Load Remote state [Common] 
#----------------------------------------------------------------------------------------------

#Common
data "terraform_remote_state" "common" {
  backend = "s3"
  config ={
    bucket = "test-devops-conf"
    region = "ap-northeast-2"
    key    = "terraform/test/tfstate/common/terraform.tfstate"
  }
}


#Network
data "terraform_remote_state" "network" {
  backend = "s3"
  config ={
    bucket = "test-devops-conf"
    region = "ap-northeast-2"
    key    = "terraform/test/tfstate/dev/eks/terraform.tfstate"
  }
}


