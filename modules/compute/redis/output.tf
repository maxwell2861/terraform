output "w_endpoint" { value = aws_elasticache_replication_group.redis.*.primary_endpoint_address }
output "r_endpoint" { value = aws_elasticache_replication_group.redis.*.reader_endpoint_address }