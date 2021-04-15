
#---------------------------------------------------------------------
# Provider Setting
#---------------------------------------------------------------------
provider "aws" {
  region  = "ap-northeast-2"
}

provider "aws" {
  alias   = "seoul"
  region  = "ap-northeast-2"
}

provider "aws" {
  alias   = "oregon"
  region  = "us-west-2"
}

terraform {
  required_version = ">= 0.14"
  backend "s3" {
    bucket = "test-devops-conf"
    region = "ap-northeast-2"
    key    = "terraform/test/tfstate/peering/terraform.tfstate"
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



