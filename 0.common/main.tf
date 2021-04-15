#------------------------------------------------------------------
# MGMT Netowrk
#------------------------------------------------------------------

module "infra-network" {
source = "../modules/network/vpc"
 region_id           = var.region_id
 prefix              = var.prefix
 env                 = var.infra_resource.env
 vpc_cidr            = var.infra_resource.vpc_cidr
}

#------------------------------------------------------------------
# Dev Netowrk
#------------------------------------------------------------------

module "dev-network" {
source = "../modules/network/vpc"
 region_id           = var.region_id
 prefix              = var.prefix
 env                 = var.dev_resource.env
 vpc_cidr            = var.dev_resource.vpc_cidr
}

#------------------------------------------------------------------
# Prod Netowrk
#------------------------------------------------------------------

module "prod-network" {
source = "../modules/network/vpc"
 region_id           = var.region_id
 prefix              = var.prefix
 env                 = var.prod_resource.env
 vpc_cidr            = var.prod_resource.vpc_cidr
}

#------------------------------------------------------------------
# Ore Netowrk
#------------------------------------------------------------------

module "ore-prod-network" {
source = "../modules/network/vpc"
providers = {
    aws = aws.oregon
  }
 region_id           = var.oregon_region_id
 prefix              = var.prefix
 env                 = var.oregon_prod_resource.env
 vpc_cidr            = var.oregon_prod_resource.vpc_cidr
}

