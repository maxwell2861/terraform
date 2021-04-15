output "nat_gw_id"       {
  description = "List of IDs of Nat Gateway"
  value = aws_nat_gateway.nat.*.id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.pub_subnet.*.id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.pri_subnet.*.id
}

output "db_subnets" {
  description = "List of IDs of db subnets"
  value       = aws_subnet.db_subnet.*.id
}

output "data_subnets" {
  description = "List of IDs of data subnets"
  value       = aws_subnet.data_subnet.*.id
}

output "privacy_subnets" {
  description = "List of IDs of privacy subnets"
  value       = aws_subnet.privacy_subnet.*.id
}

output "db_subnet_group" {
  description = "List of Group of db subnets"
  value = aws_db_subnet_group.db.*.name
}

output "privacy_subnet_group" {
  description = "List of Group of db subnets"
  value = aws_db_subnet_group.privacy.*.name
}

output "cache_subnet_group" {
  description = "List of Group of cache"
  value = aws_elasticache_subnet_group.db.*.name
}

output "nat_ips" {
  description = "List of NAT IPs"
  value = aws_eip.nat.*.public_ip
}