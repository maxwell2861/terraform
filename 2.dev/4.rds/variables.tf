#----------------------------------------------------------------------------------------------
# Project Prefix
#----------------------------------------------------------------------------------------------

variable "env" { default = "dev" }

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
    db_subnet_group    = data.terraform_remote_state.network.outputs.dev_db_subnet_group
    db_sg              = data.terraform_remote_state.network.outputs.dev_rds_sg
    common_sg          = data.terraform_remote_state.network.outputs.dev_common_sg
    az_zone            = [d.aws_availability_zones.az.names[0]ata,data.aws_availability_zones.az.names[2]]
  }

  rds_info = {
        dev-test-db = {
              name            = "db"
              type            = "db.t3.small"
              engine          = "5.7"
              port            = 3306
              username        = local.common_info.db_creds.CLUSTER_MASTER_USERNAME
              password        = local.common_info.db_creds.CLUSTER_MASTER_PASSWORD
              subnet_group    = local.network_info.db_subnet_group
              sg              = [local.network_info.db_sg,local.network_info.common_sg]
              az              = local.network_info.az_zone
              #Paremeter Groups
                family_version  = "mysql5.7"
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