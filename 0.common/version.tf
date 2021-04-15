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
    key    = "terraform/test/tfstate/common/terraform.tfstate"
  }
}