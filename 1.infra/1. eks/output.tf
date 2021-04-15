#Subnet ID
#infra Network
output "infra_pub_subnet"         { value = module.infra-subnet.public_subnets}
output "infra_pri_subnet"         { value = module.infra-subnet.private_subnets}
output "infra_data_subnet"        { value = module.infra-subnet.data_subnets}
output "infra_db_subnet"          { value = module.infra-subnet.db_subnets}
output "infra_db_subnet_group"    { value = module.infra-subnet.db_subnet_group}
output "infra_cache_subnet_group" { value = module.infra-subnet.cache_subnet_group}
output "infra_nat_ips"            { value = module.infra-subnet.nat_ips}


#Infra Security Groups
output "infra_common_sg"              {value = module.infra-common-sg.sg_id}
output "infra_service_lb_sg"          {value = module.infra-service-lb-sg.sg_id}
output "infra_hq_lb_sg"               {value = module.infra-hq-lb-sg.sg_id}
output "infra_redis_sg"               {value = module.infra-redis-sg.sg_id}
output "infra_rds_sg"                 {value = module.infra-rds-sg.sg_id}