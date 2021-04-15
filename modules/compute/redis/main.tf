
resource "aws_elasticache_parameter_group" "redis_pg" {
  count       = var.redis_count
  name        = "${var.env}-${var.prefix}-${var.name}${format("%02d",count.index+1)}-params"
  description = upper("${var.env}-${var.prefix}-${var.name}${format("%02d",count.index+1)} parameters")
  family      = "redis${var.family_version}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name       = parameter.value.name
      value      = parameter.value.value
    }
  } 

}


resource "aws_elasticache_replication_group" "redis" {
  count                         = var.redis_count
  replication_group_id          = "${var.env}-${var.prefix}-${var.name}${format("%02d",count.index+1)}"
  replication_group_description = "${var.env}-${var.prefix}-${var.name}${format("%02d",count.index+1)}"
  engine_version                = var.engine
  parameter_group_name          = element(aws_elasticache_parameter_group.redis_pg.*.id,count.index)
  multi_az_enabled              = substr(var.type,6,1) == "t" ? false : true
  node_type                     = var.type
  port                          = var.port
  number_cache_clusters         = var.replica_count

  lifecycle {
    ignore_changes = [auto_minor_version_upgrade,replication_group_description,automatic_failover_enabled]
  }

  automatic_failover_enabled    = substr(var.type,6,1) == "t" ? false : true
  auto_minor_version_upgrade    = false
  subnet_group_name             = var.subnet_group[0]
  security_group_ids            = [var.security_group]
  maintenance_window            = "thu:02:00-thu:03:00"

}

