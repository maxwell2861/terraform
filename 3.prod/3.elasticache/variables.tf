#----------------------------------------------------------------------------------------------
# Project Prefix
#----------------------------------------------------------------------------------------------

variable "env" {default = "prod"}

#----------------------------------------------------------------------------------------------
# Locals Variables Setting
#----------------------------------------------------------------------------------------------

locals {
  

  #----------------------------------------------------------------------------------------------------
  #Security Groups
  #----------------------------------------------------------------------------------------------------
  
  common_info = {
    prefix = data.terraform_remote_state.common.outputs.prefix
  }
  
  network_info = {
    db_subnet_group    = data.terraform_remote_state.network.outputs.prod_db_subnet_group
    cache_subnet_group = data.terraform_remote_state.network.outputs.prod_cache_subnet_group
    db_sg              = data.terraform_remote_state.network.outputs.prod_rds_sg
    redis_sg           = data.terraform_remote_state.network.outputs.prod_redis_sg
  }
    
  #----------------------------------------------------------------------------------------------------
  # ElastiCache Attributes [Redis]
  #----------------------------------------------------------------------------------------------------
  
  redis_info = {
        prod-test-redis = {
              name            = "redis"
              redis_count     = 1
              replica_count   = 2
              type            = "cache.t3.medium"
              port            = 6379
              engine          = "5.0.6"
              sg              = local.network_info.redis_sg
              subnet_group    = local.network_info.cache_subnet_group
              #Paremeter Groups
              family_version  = "5.0"
              parameters = {
                  cluster-mode =  {
                    #disable Cluster Mode
                    name  = "cluster-enabled"
                    value = "no"
                  }
              }
        }
  }

}

