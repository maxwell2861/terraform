
#-----------------------------------------
#
# Subnets | PUB | PRI | DB | DATA
#
#-----------------------------------------

module "infra-subnet" {
 source = "../../modules/network/subnet"
    #Env
    env                         = var.env
    #Network
    vpc_id                      = local.network_info.vpc_id
    igw_id                      = local.network_info.igw_id
    vpc_cidr                    = local.network_info.vpc_cidr
    #EKS Cluster
    eks_cluster_name            = local.cluster_names
}

#-----------------------------------------------
#
# Security Groups | Common | Service | HQ 
#
#-----------------------------------------------

#-----------------------------------------------
#
# Security Groups | Common | Service | HQ 
#
#-----------------------------------------------

module "infra-common-sg"  {
    source = "../../modules/network/security_groups/common"
    #Env
    env                         = var.env
    prefix                      = local.common_info.prefix
    #SG
    vpc_id                      = local.network_info.vpc_id
    sg_name                     = local.sg_info.common.name
    sg_desc                     = local.sg_info.common.desc
    sg_inbounds                 = local.sg_info.common.inbound_set
    #EKS Cluster Owned
    eks_cluster_name            = local.cluster_names
}

module "infra-service-lb-sg"  {
    source = "../../modules/network/security_groups/other"
    #Env
    env                         = var.env
    prefix                      = local.common_info.prefix
    #SG
    vpc_id                      = local.network_info.vpc_id
    sg_name                     = local.sg_info.service_lb.name
    sg_desc                     = local.sg_info.service_lb.desc
    sg_inbounds                 = local.sg_info.service_lb.inbound_set
}

module "infra-hq-lb-sg"  {
    source = "../../modules/network/security_groups/other"
    #Env
    env                         = var.env
    prefix                      = local.common_info.prefix
    #SG
    vpc_id                      = local.network_info.vpc_id
    sg_name                     = local.sg_info.hq_lb.name
    sg_desc                     = local.sg_info.hq_lb.desc
    sg_inbounds                 = local.sg_info.hq_lb.inbound_set
}

module "infra-redis-sg"  {
    source = "../../modules/network/security_groups/other"
    #Env
    env                         = var.env
    prefix                      = local.common_info.prefix
    #SG
    vpc_id                      = local.network_info.vpc_id
    sg_name                     = local.sg_info.redis.name
    sg_desc                     = local.sg_info.redis.desc
    sg_inbounds                 = local.sg_info.redis.inbound_set
}

module "infra-rds-sg"  {
    source = "../../modules/network/security_groups/other"
    #Env
    env                         = var.env
    prefix                      = local.common_info.prefix
    #SG
    vpc_id                      = local.network_info.vpc_id
    sg_name                     = local.sg_info.rds.name
    sg_desc                     = local.sg_info.rds.desc
    sg_inbounds                 = local.sg_info.rds.inbound_set
}

/*
module "infra-common-rules"  {
    source = "../../modules/network/security_groups_rules"
    depends_on = [module.infra-common-sg]
    sg_id                       = local.sg_rule.common.sg_id
    sg_rules                    = local.sg_rule.common.rules
}
*/

#-----------------------------------------------
#
# Create EKS Cluster / Node Group
#
#-----------------------------------------------

module "infra-front" {
 source = "../../modules/compute/eks"
    depends_on = [module.infra-common-sg, module.infra-subnet]
    #Env
    env                         = var.env
    prefix                      = local.common_info.prefix
    #Network
    vpc_id                      = local.network_info.vpc_id
    vpc_cidr                    = local.network_info.vpc_cidr
    #Subnet
    worker_node_subnets         = module.infra-subnet.private_subnets
    cluster_subnets             = module.infra-subnet.private_subnets
    #EKS Cluster
    eks_cluster_name            = local.cluster_info.front.eks_cluster_name
    eks_cluster_role            = local.cluster_info.front.eks_cluster_role
    eks_cluster_version         = local.cluster_info.front.eks_cluster_version
    eks_cluster_sg_id           = module.infra-common-sg.sg_id
    #EKS Worker Node Group                 
    eks_node_group_role         = local.cluster_info.front.eks_node_role
    eks_node_type               = local.cluster_info.front.eks_node_type
    eks_node_sg_id              = module.infra-common-sg.sg_id
    ssh_key                     = local.common_info.ssh_key
    #Launch_template
    user_data                   = local.cluster_info.front.user_data
    #AutoScaling            
    desired_size                = local.cluster_info.front.desired_size
    min_size                    = local.cluster_info.front.min_size
    max_size                    = local.cluster_info.front.max_size
}





