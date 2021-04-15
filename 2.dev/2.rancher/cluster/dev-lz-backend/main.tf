
module "registry" {
  source = "../../../../modules/k8s/registry/"
    #depends_on = [module.k8s]

  #Docker Registry
  registry_namepaces = local.cluster_info["namespaces"]
  registry_address   = local.registry_address
  registry_user      = local.registry_user
  registry_password  = local.registry_password

}


module "k8s" {
  source = "../../../../modules/k8s/project/"
  
  #k8s cluster info
  project_name             = local.cluster_info["project_name"]
  cluster_id               = local.cluster_info["id"]
  cluster_name             = local.cluster_info["name"]
  namespaces               = local.cluster_info["namespaces"]  
  #Ingress Controller
  alb_yaml                 = local.ingress_controller["manifist"]
  dot_com_acm              = local.ingress_controller["dot_com_acm"]
  dot_net_acm              = local.ingress_controller["dot_net_acm"]
  alb_subnet               = local.ingress_controller["subnets"]
  alb_sg                   = local.ingress_controller["sg"]
  
}