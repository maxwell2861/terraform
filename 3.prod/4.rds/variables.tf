#----------------------------------------------------------------------------------------------
# Project Prefix
#----------------------------------------------------------------------------------------------

variable "env" { default = "prod" }

#------------------------------------------------
# RDS Create Variables
#------------------------------------------------

locals {
  
    #COMMON
  common_info = {
    prefix         = data.terraform_remote_state.common.outputs.prefix
    db_creds       = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
  }
  
  network_info = { 
    db_subnet_group    = data.terraform_remote_state.network.outputs.prod_db_subnet_group
    common_sg          = data.terraform_remote_state.network.outputs.prod_common_sg
    db_sg              = data.terraform_remote_state.network.outputs.prod_rds_sg
    az_zone            = [data.aws_availability_zones.az.names[0],data.aws_availability_zones.az.names[2]]
  }

  rds_info = {
        prod-test-rds = {
              name            = "rds"
              type            = "db.t3.small"
              engine          = "5.7.mysql_aurora.2.09.0"
              port            = 3306
              username        = local.common_info.db_creds.CLUSTER_USERNAME
              password        = local.common_info.db_creds.CLUSTER_PASSWORD
              subnet_group    = local.network_info.db_subnet_group
              sg              = local.network_info.db_sg
              az              = local.network_info.az_zone
              #Paremeter Groups
                family_version  = "aurora-mysql5.7"
                parameters = {
                    binlog-format =  {
                      #disable Cluster Mode
                      apply_method = "pending-reboot"
                      name  = "binlog_format"
                      value = "MIXED"
                    }
                }
        }
  }
}