#DB Instance Parameter Group [For Dev]
resource "aws_db_parameter_group" "mysql" {
  count       = var.env == "dev" ? 1 : 0
  name        = "${var.env}-${var.prefix}-${var.name}-params"
  family      =  var.family_version
  description = upper("${var.env}-${var.prefix}-${var.name} parameters")
  
  dynamic "parameter" {
    for_each = var.parameters
    content {
      apply_method = parameter.value.apply_method
      name         = parameter.value.name
      value        = parameter.value.value
    }
  } 
}

#Cluster Parameter Group [For Prod] 
resource "aws_rds_cluster_parameter_group" "cpg" {
  count       = var.env == "prod" ? 1 : 0
  name        = "${var.env}-${var.prefix}-${var.name}-params"
  family      =  var.family_version
  description = upper("${var.env}-${var.prefix}-${var.name} parameters")
  
  dynamic "parameter" {
    for_each = var.parameters
    content {
      apply_method = parameter.value.apply_method
      name         = parameter.value.name
      value        = parameter.value.value
    }
  } 

}

#DB Instance [For Dev]
resource "aws_db_instance" "mysql" {
  count                           = var.env == "dev" ? 1 : 0
  allocated_storage               = 50
  engine                          = "mysql"
  engine_version                  = var.engine
  instance_class                  = var.type
  name                            = "${var.env}_${var.prefix}_${var.name}${format("%02d",count.index+1)}"
  identifier                      = "${var.env}-${var.prefix}-${var.name}${format("%02d",count.index+1)}"
  port                            = var.port
  db_subnet_group_name            = var.subnet_group[0]
  vpc_security_group_ids          = var.security_group
  username                        = var.username
  password                        = var.password
  parameter_group_name            = aws_db_parameter_group.mysql[0].id
  backup_retention_period         = 7 
  skip_final_snapshot             = true
}


#RDS Cluster [For Prod]
resource "aws_rds_cluster" "cluster" {
  lifecycle {
    ignore_changes = [master_password]
  }
  count                           = var.env == "prod" ? 1 : 0
  cluster_identifier              =  "${var.env}-${var.prefix}-${var.name}"
  master_username                 = var.username
  master_password                 = var.password
  engine                          = "aurora-mysql"
  engine_version                  = var.engine
  db_subnet_group_name            = var.subnet_group[0]
  enabled_cloudwatch_logs_exports = ["slowquery", "error"] 
  deletion_protection             = true
  preferred_maintenance_window    = "Thu:02:00-Thu:03:00"
  preferred_backup_window         = "18:00-18:30"
  port                            = var.port
  storage_encrypted               = "false"
  backup_retention_period         = 7 
  backtrack_window                = 0
  vpc_security_group_ids          = var.security_group
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cpg[0].id
  skip_final_snapshot             = true
}

#RDS DB Instances [For Prod]
resource "aws_rds_cluster_instance" "db_instance" {
  count              = var.env == "prod" ? 2 : 0
  identifier         = "${var.env}-${var.prefix}-${var.name}-${substr(element(var.az,count.index),-1,1)}"
  cluster_identifier = aws_rds_cluster.cluster[0].id
  instance_class     = var.type
  engine             = "aurora-mysql"
  engine_version     = var.engine
  auto_minor_version_upgrade = "false"


}

