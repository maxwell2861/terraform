
#Subnet ID
#prod Network
output "prod_pub_subnet"         { value = module.prod-subnet.public_subnets}
output "prod_pri_subnet"         { value = module.prod-subnet.private_subnets}
output "prod_privacy_subnet"     { value = module.prod-subnet.privacy_subnets}
output "prod_data_subnet"        { value = module.prod-subnet.data_subnets}
output "prod_db_subnet"          { value = module.prod-subnet.db_subnets}
output "prod_db_subnet_group"    { value = module.prod-subnet.db_subnet_group}
output "prod_cache_subnet_group" { value = module.prod-subnet.cache_subnet_group}


#PROD Security Groups
output "prod_common_sg"              {value = module.prod-common-sg.sg_id}
output "prod_service_lb_sg"          {value = module.prod-service-lb-sg.sg_id}
output "prod_hq_lb_sg"               {value = module.prod-hq-lb-sg.sg_id}
output "prod_redis_sg"               {value = module.prod-redis-sg.sg_id}
output "prod_rds_sg"                 {value = module.prod-rds-sg.sg_id}