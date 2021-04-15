module "rds" {
source = "../../modules/compute/rds"
#common
env                 = var.env
prefix              = local.common_info.prefix
#RDS info
name                = local.rds_info.prod-test-rds["name"]
engine              = local.rds_info.prod-test-rds["engine"]
type                = local.rds_info.prod-test-rds["type"]
port                = local.rds_info.prod-test-rds["port"]
security_group      = local.rds_info.prod-test-rds["sg"]
subnet_group        = local.rds_info.prod-test-rds["subnet_group"]
username            = local.rds_info.prod-test-rds["username"]
password            = local.rds_info.prod-test-rds["password"]
az                  = local.rds_info.prod-test-rds["az"]
family_version      = local.rds_info.prod-test-rds["family_version"]
parameters          = local.rds_info.prod-test-rds["parameters"]

}