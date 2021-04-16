#----------------------------------------------------------------------------------------------
# Project Prefix
#----------------------------------------------------------------------------------------------

variable "prefix"    { default = "test" }

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
#Server Attributes
#----------------------------------------------------------------------------------------------------
  
  ec2_game = {
    count         = 1
    ami           = local.ami["linux"]
    instance_type = "t2.medium"
    userdata      = file("../0.userdata/stg_linux_base.sh")
    subnet        = local.subnet["stg_pub"]
    sg            = [local.sg["common"]]
    iam_profile   = local.ec2_role["stg"]
    ec2_key       = local.ec2_key
    server_name   = "${local.prefix}-${local.env["stg"]}-game"
    tag_role      = "game"
  }


#----------------------------------------------------------------------------------------------------
# Do not Touch 
#----------------------------------------------------------------------------------------------------
  
  #Common
  prefix      = var.prefix
  bucketname  = "test-${local.prefix}-ops"
  region_id   = var.region_id

  # AMI
   ami = {
    linux      =  data.terraform_remote_state.common.outputs.linux_base_ami
    
    #windows 필요시 주석 제거
    #windows   =  data.terraform_remote_state.common.outputs.windows_base_ami
    }

  #Environment
  env = {
    mgmt       = "mgmt"
    stg        = "stg"
    prd        = "prd"
    ios        = "ios"
    stress     = "stress"
  }

  #Subnet 
    subnet = {
    stg_pub     = data.terraform_remote_state.common.outputs.stg_pub_subnet
    stg_pri     = data.terraform_remote_state.common.outputs.stg_pri_subnet
    stg_db      = data.terraform_remote_state.common.outputs.stg_db_subnet
    prd_pub     = data.terraform_remote_state.common.outputs.prd_pub_subnet
    prd_pri     = data.terraform_remote_state.common.outputs.prd_pri_subnet
    prd_db      = data.terraform_remote_state.common.outputs.prd_db_subnet
    prd_aws     = data.terraform_remote_state.common.outputs.prd_aws_subnet
  }

  #EC2_key 
  ec2_key   = data.terraform_remote_state.common.outputs.ec2_key_name
  
  #EC2_role 
  ec2_role = {
    stg     = data.terraform_remote_state.common.outputs.stg_profile_id
    prd     = data.terraform_remote_state.common.outputs.prd_profile_id
  }
}

