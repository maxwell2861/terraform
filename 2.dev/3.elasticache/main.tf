#--------------------------------------------------------------
# 0. Elastic Cache [Redis/Replica]  :: [Only t2 Type]
#--------------------------------------------------------------

module "dev-test-redis" {

source = "../../modules/compute/redis"
#common
env                     = var.env
prefix                  = local.common_info.prefix
#redis info
redis_count             = local.redis_info.dev-test-redis["redis_count"]
replica_count           = local.redis_info.dev-test-redis["replica_count"]
name                    = local.redis_info.dev-test-redis["name"]
engine                  = local.redis_info.dev-test-redis["engine"]
type                    = local.redis_info.dev-test-redis["type"]
port                    = local.redis_info.dev-test-redis["port"]
security_group          = local.redis_info.dev-test-redis["sg"]
subnet_group            = local.redis_info.dev-test-redis["subnet_group"]
family_version          = local.redis_info.dev-test-redis["family_version"]
parameters              = local.redis_info.dev-test-redis["parameters"]

}


