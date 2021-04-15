# Stage Resource 


> Terraform Provisioning for Infra Network Resource


**Table of Contents**  
- [Release Notes](#Release-Notes)
- [Terraform Provisionig List](#Terraform-Provisionig-List)
  - [EKS](#eks)
  - [Rancher](#Rancher)
  - [EC2](#ec2)
  - [ElastiCache](#ElastiCache)
  - [RDS](#RDS)

## Release Notes
#
```

2021-03-16
 - Update

```

## Terraform Provisionig List
#
```

 ├── 1. eks
 ├── 2. rancher
 ├── 3. ec2
 ├── 4. elastiCache
 ├── 5. RDS
 
 
```

---
## EKS

### EKS Cluster & Managed Node Group 을 생성합니다. 
 
```terraform


# 생성할 Cluster 에 적용할 Subnet 을 생성합니다.

module "infra-subnet" {
 source = "../../modules/network/subnet"
    #Env
    env                         = var.env
    #Network
    vpc_id                      = local.infra_resource.vpc_id
    igw_id                      = local.infra_resource.igw_id
    vpc_cidr                    = local.infra_resource.vpc_cidr
    region_id                   = var.region_id
    #EKS Cluster -> Subnet Setting
    eks_cluster_name            = [local.front_resource.eks_cluster_name]

}

# Cluster / Worker Node 를 생성합니다.
module "eks-cluster" {
 source = "../../modules/compute/eks"
    #Env
    env                         = var.env
    prefix                      = var.prefix
    #Network
    vpc_id                      = local.infra_resource.vpc_id
    vpc_cidr                    = local.infra_resource.vpc_cidr
    #Subnet
    pub_subnets                 = module.infra-subnet.public_subnets
    pri_subnets                 = module.infra-subnet.private_subnets
    #EKS Cluster
    eks_cluster_name            = local.front_resource.eks_cluster_name
    eks_cluster_role            = data.terraform_remote_state.common.outputs.eks_cluster_role
    eks_cluster_version         = local.front_resource.eks_cluster_version
    eks_cluster_sg_id           = aws_security_group.sg_infra_common.id
    #EKS Worker Node Group                 
    eks_node_group_role         = data.terraform_remote_state.common.outputs.eks_node_role
    eks_node_type               = local.front_resource.eks_node_type
    eks_node_sg_id              = local.front_resource.eks_node_sg_id
    ssh_key                     = var.ssh_key
    #Launch_template
    user_data                   = local.front_resource.user_data
    #AutoScaling            
    desired_size                = local.front_resource.desired_size
    min_size                    = local.front_resource.min_size
    max_size                    = local.front_resource.max_size
}

```

---
## Rancher

### Cluster Provisioning 후 Namespaces / Sample Pod / Sample Service / Ingress Controller  를 생성합니다.

``` terraform

# Sample Code 


module "cluster" {
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

```


## EC2

EC2 Provisioning Code ( With Module)

```terraform
EC2
```

## ElastiCache

ElastiCache Provisioning (With Module )


```terraform

ElastiCache

```


## RDS
RDS Provisioning (With Module)


```terraform

RDS

```