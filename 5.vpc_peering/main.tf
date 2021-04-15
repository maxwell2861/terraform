#--------------------------------------
# Infra Network To Dev
#--------------------------------------

module "dev" {
    source = "../modules/network/peering"
    env             = local.infra_resource.env
    vpc_id          = local.infra_resource.vpc_id 
    peer_vpc_env    = local.dev_resource.env
    peer_vpc_id     = local.dev_resource.vpc_id
}

#--------------------------------------
# Infra Network To Prod
#--------------------------------------

module "prod-peering" {
    source = "../modules/network/peering"
    env             = local.infra_resource.env
    vpc_id          = local.infra_resource.vpc_id 
    peer_vpc_env    = local.prod_resource.env
    peer_vpc_id     = local.prod_resource.vpc_id
}

