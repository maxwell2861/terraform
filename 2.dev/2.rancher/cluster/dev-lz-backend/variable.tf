
#----------------------------------------------
# Cluster  Variables
#----------------------------------------------
 variable "env"       { default  = "dev" }
 variable "role"      { default  = "backend"}    

#------------------------------------------
# Cluster Attributes
#------------------------------------------

data "aws_eks_cluster"    "eks"                    { name = local.cluster_name }
data "rancher2_cluster"   "eks"                    { name = local.cluster_name }
data "aws_secretsmanager_secret_version" "rancher" { secret_id = "rancher/rancher3"} 

locals{
  
    common_info     = {
        prefix              = data.terraform_remote_state.common.outputs.prefix   
        #For Rancher
        project_name        = "test"
    }
  
 
  #Docker Registry  
  creds            = jsondecode(data.aws_secretsmanager_secret_version.rancher.secret_string)
  registry_address  = local.creds.registry_address 
  registry_user     = local.creds.registry_user
  registry_password = local.creds.registry_password
  cluster_name     = "${var.env}-${local.common_info.prefix}-${var.role}"


  #k8s Cluster
  cluster_info = {
      project_name     = local.common_info.project_name
      name             = "${local.env}-${local.common_info.prefix}-${local.role}"
      id               = data.rancher2_cluster.eks.id
      namespaces       = ["a-service","b-service","c-service"]
  }

  # AWS Loadbalancer Info [ACM / Security Groups]
 ingress_controller = {
    manifist             = file("../../manifest/aws-alb-ingress.yaml")
    dot_com_acm          = data.terraform_remote_state.acm.outputs.com_cert_arn 
    dot_net_acm          = data.terraform_remote_state.acm.outputs.net_cert_arn
    subnets              = data.terraform_remote_state.network.outputs.dev_elb_subnet
    sg                   = data.terraform_remote_state.network.outputs.sg_dev_hq_elb
  }
}
