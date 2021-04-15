output "aurora_endpoint" {value = aws_rds_cluster.cluster.*.endpoint}
output "mysql_endpoint"  {value = aws_db_instance.mysql.*.endpoint}

