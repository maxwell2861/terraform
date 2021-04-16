
#-----------------------------------------------------------
# Provider / Backend Setting
#-----------------------------------------------------------

provider "aws" {
  region  = var.region_id
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "test-init-ops"
    region = "ap-northeast-2"
    key    = "terraform/init/tfstate/infra/ec2/terraform.tfstate"
  }
}

#-----------------------------------------------------------
# [Stage]  game
#-----------------------------------------------------------

module "bastion-host" {
source = "../../../modules/compute/stage/linux/public"
ec2_count       = local.ec2_game["count"]
ami             = local.ec2_game["ami"]
instance_type   = local.ec2_game["instance_type"]
userdata        = local.ec2_game["userdata"]
subnet          = local.ec2_game["subnet"]
sg              = local.ec2_game["sg"]
iam_profile     = local.ec2_game["iam_profile"]
ec2_key         = local.ec2_key 
server_name     = local.ec2_game["server_name"]
tag_role        = local.ec2_game["tag_role"]
}