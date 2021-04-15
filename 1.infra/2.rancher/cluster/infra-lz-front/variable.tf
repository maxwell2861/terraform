#------------------------------------------
# Cluster Attributes
#------------------------------------------

data "aws_eks_cluster"    "eks"                    { name = local.k8s_cluster_name }
data "rancher2_cluster"   "eks"                    { name = local.k8s_cluster_name }
data "aws_secretsmanager_secret_version" "rancher" { secret_id = "rancher/rancher4"} 

locals{
  
  project_name     = "test"
  k8s_cluster_name = "infra-test-front"
  k8s_cluster_id   = data.rancher2_cluster.eks.id
  namespaces       = ["dev","beta","qa","mirror","prod"]
  creds            = jsondecode(data.aws_secretsmanager_secret_version.rancher.secret_string)
  registry_address  = local.creds.registry_address 
  registry_user     = local.creds.registry_user
  registry_password = local.creds.registry_password

}
