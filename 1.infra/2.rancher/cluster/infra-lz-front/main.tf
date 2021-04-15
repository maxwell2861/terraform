
module "infra-test-front" {
  source = "../../modules/rancher/project/"
  project_name      = local.project_name
  cluster_id        = local.k8s_cluster_id
  cluster_name      = local.k8s_cluster_name
  namespaces        = local.namespaces
  registry_address  = local.registry_address
  registry_user     = local.registry_user
  registry_password = local.registry_password
  alb_yaml          = file("../../manifest/aws-alb-ingress.yaml")
}





