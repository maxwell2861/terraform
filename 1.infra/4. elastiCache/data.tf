#----------------------------------------------------------------------------------------------
# Remote state [Common] / [Security Group]
#----------------------------------------------------------------------------------------------
#subnet
data "terraform_remote_state" "common" {
  backend = "s3"
  config ={
    bucket = local.bucketname
    key    = local.tfstate["common"]
    region = local.region_id
  }
}

#security group
data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = local.bucketname
    key    = local.tfstate["stg_sg"]
    region = local.region_id
  }
}

