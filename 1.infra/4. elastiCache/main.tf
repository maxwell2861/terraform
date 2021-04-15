
#-------------------------------------------------
# Create Parameter Group [Production]
#-------------------------------------------------
resource "aws_elasticache_parameter_group" "parameter_group" {
  name   = "${local.prefix}-${local.env["stg"]}-pg"
  family = local.pg["redis50"]
  parameter {
    #disable Cluster Mode
    name  = "cluster-enabled"
    value = "no"
  }
}

#--------------------------------------------------------------
# 0. Elastic Cache [Redis/Replica]  :: [Only t2 Type]
#--------------------------------------------------------------

module "stg-game-cache" {
source = "../../modules/compute/redis/replica_t2"
elc_count                   = local.elc_game["count"]
#Parameter Group
elc_parameter_group          = "${aws_elasticache_parameter_group.parameter_group.name}"
#Elastic Cache
elc_name                    = local.elc_game["name"]
elc_engine                  = local.elc_game["engine"]
elc_type                    = local.elc_game["type"]
elc_port                    = local.elc_game["port"]
elc_security_group          = local.elc_game["sg"]
elc_subnet_group            = local.elc_game["subnet_group"]
# Add Replica Count
elc_replica_count           = local.elc_game["replica_count"]
}


