module "dev-test-rds" {
source = "../../modules/compute/rds"
#common
env                 = var.env
prefix              = local.common_info.prefix
#RDS info
name                = local.rds_info.dev-test-rds["name"]
engine              = local.rds_info.dev-test-rds["engine"]
type                = local.rds_info.dev-test-rds["type"]
port                = local.rds_info.dev-test-rds["port"]
security_group      = local.rds_info.dev-test-rds["sg"]
subnet_group        = local.rds_info.dev-test-rds["subnet_group"]
username            = local.rds_info.dev-test-rds["username"]
password            = local.rds_info.dev-test-rds["password"]
az                  = local.rds_info.dev-test-rds["az"]
family_version      = local.rds_info.dev-test-rds["family_version"]
parameters          = local.rds_info.dev-test-rds["parameters"]

}