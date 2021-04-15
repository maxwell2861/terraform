
#Subnet ID
#Dev Network
output "dev_pub_subnet"         { value = module.dev-subnet.public_subnets}
output "dev_elb_subnet"         { value = "${module.dev-subnet.public_subnets[0]},${module.dev-subnet.public_subnets[1]}"}
output "dev_pri_subnet"         { value = module.dev-subnet.private_subnets}
output "dev_data_subnet"        { value = module.dev-subnet.data_subnets}
output "dev_db_subnet"          { value = module.dev-subnet.db_subnets}
output "dev_db_subnet_group"    { value = module.dev-subnet.db_subnet_group}
output "dev_cache_subnet_group" { value = module.dev-subnet.cache_subnet_group}
output "dev_nat_ips"            { value = module.dev-subnet.nat_ips}


#Dev Security Groups
output "dev_common_sg"              {value = module.dev-common-sg.sg_id}
output "dev_service_lb_sg"          {value = module.dev-service-lb-sg.sg_id}
output "dev_hq_lb_sg"               {value = module.dev-hq-lb-sg.sg_id}
output "dev_redis_sg"               {value = module.dev-redis-sg.sg_id}
output "dev_rds_sg"                 {value = module.dev-rds-sg.sg_id}