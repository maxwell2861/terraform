#----------------------------------------------------------------------------------------------
# Project Prefix
#----------------------------------------------------------------------------------------------

variable "prefix"    { default = "test" }
variable "region_id" { default = "ap-northeast-2" }

#----------------------------------------------------------------------------------------------
# Locals Variables Setting
#----------------------------------------------------------------------------------------------

locals {
  

  #----------------------------------------------------------------------------------------------------
  #Security Groups
  #----------------------------------------------------------------------------------------------------
  sg = {
    common = data.terraform_remote_state.sg.outputs.sg_stg_common
  }
    
  #----------------------------------------------------------------------------------------------------
  # ElastiCache Attributes [Redis]
  #----------------------------------------------------------------------------------------------------
  
  elc_game = {
    count           = 1
    name            = "${local.prefix}-${local.env["stg"]}-game"
    engine          = "5.0.0"
    parameter_group = local.pg["redis50"]
    type            = "cache.m4.large"
    port            = "7000"
    sg              = [local.sg["common"]]
    subnet_group    = local.subnet_group["stg_cache"]
    replica_count   = "2"
  }


  #----------------------------------------------------------------------------------------------------
  # Do not Touch 
  #----------------------------------------------------------------------------------------------------
  #Common
  
  prefix      = var.prefix
  bucketname  = "test-${local.prefix}-ops"
  region_id   = var.region_id

  # Environment

   env = {
    mgmt       = "mgmt"
    stg        = "stg"
    prd        = "prd"
    ios        = "ios"
    stress     = "stress"
  }

 #Subnet Group
  subnet_group = {
    stg_db       = data.terraform_remote_state.common.outputs.stg_db_subnet_group
    stg_cache    = data.terraform_remote_state.common.outputs.stg_cache_subnet_group
    prd_db       = data.terraform_remote_state.common.outputs.prd_db_subnet_group
    prd_cache    = data.terraform_remote_state.common.outputs.prd_cache_subnet_group
  }

  #Parameter Group
  pg = {
    redis32     = "redis3.2"
    redis40     = "redis4.0"
    redis50     = "redis5.0"
  }

  #Remote tfstate 
  tfstate = { 
    common   = "terraform/${local.prefix}/tfstate/common"
    stg_sg   = "terraform/${local.prefix}/tfstate/${local.env["stg"]}/sg/terraform.tfstate"
    stg_ec2  = "terraform/${local.prefix}/tfstate/${local.env["stg"]}/ec2/terraform.tfstate"
    stg_elb  = "terraform/${local.prefix}/tfstate/${local.env["stg"]}/elb/terraform.tfstate"
    stg_elc  = "terraform/${local.prefix}/tfstate/${local.env["stg"]}/elc/terraform.tfstate"
  }


  

}

