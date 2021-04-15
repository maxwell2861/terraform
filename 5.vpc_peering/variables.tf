
locals {

   
  infra_resource = {
      env          = "infra"
      vpc_id       = data.terraform_remote_state.common.outputs.infra_vpc_id
  }
  
  dev_resource = {
      env          = "dev"
      vpc_id       = data.terraform_remote_state.common.outputs.dev_vpc_id
  }
  
  prod_resource = {
      env          = "prod"
      vpc_id       = data.terraform_remote_state.common.outputs.prod_vpc_id
  }
  

}