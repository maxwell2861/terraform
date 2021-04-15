#-------------------------------------------------
# Common
#-------------------------------------------------
output "prefix"                      { value = var.prefix }
output "ssh_key"                     { value = var.ssh_key }

#-------------------------------------------------
# VPC ID
#-------------------------------------------------

output "infra_vpc_id"              { value = module.infra-network.vpc_id }
output "dev_vpc_id"                { value = module.dev-network.vpc_id }
output "prod_vpc_id"               { value = module.prod-network.vpc_id }
output "ore_prod_vpc_id"           { value = module.ore-prod-network.vpc_id }

#-------------------------------------------------
# VPC CIDR
#-------------------------------------------------

output "infra_vpc_cidr"              { value = module.infra-network.vpc_cidr }
output "dev_vpc_cidr"                { value = module.dev-network.vpc_cidr }
output "prod_vpc_cidr"               { value = module.prod-network.vpc_cidr }
output "ore_prod_vpc_cidr"           { value = module.ore-prod-network.vpc_cidr }

#-------------------------------------------------
# IGW ID
#-------------------------------------------------

output "infra_igw_id"              { value = module.infra-network.igw_id }
output "dev_igw_id"                { value = module.dev-network.igw_id }
output "prod_igw_id"               { value = module.prod-network.igw_id }
output "ore_prod_igw_id"           { value = module.ore-prod-network.igw_id }


#-------------------------------------------------
# IAM Role Profile
#-------------------------------------------------
output "ec2_profile_id"           { value = aws_iam_instance_profile.ec2_profile.id }
output "ecs_profile_id"           { value = aws_iam_instance_profile.ecs_profile.id }
output "eks_cluster_role"         { value = aws_iam_role.role_eks_cluster.arn}
output "eks_node_role"            { value = aws_iam_role.role_eks_worker_node.arn}

#-------------------------------------------------
# CERT
#-------------------------------------------------

output "com_cert_arn"           { value = "arn:aws:acm:ap-northeast-2:818261576161:certificate/f58bc48f-6f04-4254-91b8-1a05bf3083b5" }
output "net_cert_arn"           { value = "	arn:aws:acm:ap-northeast-2:818261576161:certificate/4a06864f-7a55-4dc8-81b7-62aa1445d6ea" }

#-------------------------------------------------
# Office IP List
#-------------------------------------------------
 
output "test_office_ip"       { value = ["211.192.194.241/32","211.192.194.242/32","211.192.194.243/32"]}
output "kidari_office_ip"       { value = ["58.127.255.234/32","58.234.128.218/32","123.140.39.131/32","123.140.39.132/32","219.122.179.42/32","115.92.254.146/32","110.11.166.218/32"]}
output "open_vpn_ip"            { value = ["52.79.73.44/32","52.196.76.220/32","35.199.21.48/32"]} 
output "rancher_ip"             { value = ["52.79.73.44/32"]} 
