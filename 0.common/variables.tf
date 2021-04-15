#----------------------------------------------
# COMMON | Network Resource
#----------------------------------------------
variable "prefix"           {default = "test"}
variable "ssh_key"          {default = "gateway-default"}
variable "region_id"        {default = "ap-northeast-2"} 
variable "oregon_region_id" {default = "us-west-2" }

variable "infra_resource" {
  default = {
      env       = "infra"
      vpc_cidr  = "10.255.0.0/16"
    }
}

variable "dev_resource" {
  default = {
      env       = "dev"
      vpc_cidr  = "192.168.0.0/16"
    }
}

variable "prod_resource" {
  default = {
      env       = "prod"
      vpc_cidr  = "10.1.0.0/16"
    }
}

#----------------------------------------------
# IAM Group Policy [Amazon managed]
#----------------------------------------------
locals {
  devops_policy_arn    = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  developers_policy_arn = [

    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/IAMUserChangePassword",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceFullAccess",
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
  securityadmin_policy_arn = [

    "arn:aws:iam::aws:policy/AmazonGuardDutyFullAccess",
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AWSSecurityHubFullAccess"
  ]
  application_policy_arn = [

    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
  deploy_policy_arn = [

    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/service-role/CloudWatchEventsInvocationAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceFullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  ]

#----------------------------------------------
# IAM Role Policy [Amazon managed]
#----------------------------------------------
  ec2_policy_arn = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  ]
  

  eks_policy_arn = [
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
   
  ]





}