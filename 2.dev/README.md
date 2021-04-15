# Stage Resource 


> Terraform Provisioning for Dev Network Resource


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
 ├── 3. elastiCache
 ├── 4. RDS
 
 
```

---
## EKS

### EKS Cluster & Managed Node Group 을 생성합니다. 
 
```terraform


# EKS Cluster/Worker Node 에 사용될 Subnet 을 생성합니다.

Subnet 에  해당 Cluster "shared" 설정이 필수이므로 EKS Cluster와 같은 Working Directory 에서 생성합니다.

module "dev-subnet" {
 source = "../../modules/network/subnet"
    #Env
    env                         = var.env
    #Network
    vpc_id                      = local.network_info.vpc_id
    igw_id                      = local.network_info.igw_id
    vpc_cidr                    = local.network_info.vpc_cidr
    region_id                   = var.region_id
    #EKS Cluster
    eks_cluster_name            = local.cluster_names
}


# Cluster / Worker Node 를 생성합니다.
module "eks-cluster" {
 source = "../../modules/compute/eks"
    #Env
    env                         = var.env
    prefix                      = local.prefix
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

## ElastiCache (Redis)

Redis Provisioning Code ( With Module)

```terraform

#sample Code

module "dev-test-redis" {

source = "../../modules/compute/redis"
#common
env                     = var.env
prefix                  = local.common_info.prefix
#redis info
redis_count             = local.redis_info.dev-test-redis["redis_count"]
replica_count           = local.redis_info.dev-test-redis["replica_count"]
name                    = local.redis_info.dev-test-redis["name"]
engine                  = local.redis_info.dev-test-redis["engine"]
type                    = local.redis_info.dev-test-redis["type"]
port                    = local.redis_info.dev-test-redis["port"]
security_group          = local.redis_info.dev-test-redis["sg"]
subnet_group            = local.redis_info.dev-test-redis["subnet_group"]
family_version          = local.redis_info.dev-test-redis["family_version"]
parameters              = local.redis_info.dev-test-redis["parameters"]

}

#variables

  redis_info = {
        dev-test-redis = {
              name            = "redis"
              redis_count     = 1
              replica_count   = 2
              type            = "cache.t3.medium"
              port            = 6379
              engine          = "5.0.6"
              sg              = local.network_info.redis_sg
              subnet_group    = local.network_info.cache_subnet_group
              #Paremeter Groups
              family_version  = "5.0"
              parameters = {
                  cluster-mode =  {
                    #disable Cluster Mode
                    name  = "cluster-enabled"
                    value = "no"
                  }
              }
        }
  }

```

## RDS
RDS Provisioning (With Module)

Dev Environment 는  AuroraMYQL 이 아닌 MySQL Community 로 생성하게끔 설정되어 있습니다. (cost save 목적)
만약 QA 환경일 경우 Prod 환경과 동일한 set 을 만들 필요성은 있음..!

```terraform

rds_info = {
        dev-test-db = {
              name            = "db"
              type            = "db.t3.small"
              engine          = "5.7"
              port            = 3306
              username        = local.common_info.db_creds.CLUSTER_MASTER_USERNAME
              password        = local.common_info.db_creds.CLUSTER_MASTER_PASSWORD
              subnet_group    = local.network_info.db_subnet_group
              sg              = [local.network_info.db_sg,local.network_info.common_sg]
              az              = local.network_info.az_zone
              #Paremeter Groups
                family_version  = "mysql5.7"
                parameters = {
                    binlog-format =  {
                      #disable Cluster Mode
                      apply_method = "pending-reboot"
                      name  = "binlog_format"
                      value = "MIXED"
                    }
                }
        }
  }
}

```