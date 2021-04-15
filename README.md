# test Terraform module

하기 3개 Provider 를 결합한 Terraform Resource Code 를 정의 합니다. <a href="https://terraform.io">
    <img src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" alt="Terraform logo" title="Terrafpr," align="right" height="80" />
</a>


* [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)  
* [Rancher](https://registry.terraform.io/providers/rancher/rancher2/latest/docs)
* [Kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)

## Provisioning Order

```
Common -> Infra -> Dev -> Production 
```


## Requirements
-	[Terraform](https://www.terraform.io/downloads.html) 0.14.x
    - [What's_New_Terraform0.14](https://www.hashicorp.com/blog/announcing-hashicorp-terraform-0-14-general-availability) 

## Usage

### Cache Path Setting

``` shell
    # 개별 Directory 내 plugin 중복제거 및 설치 속도 향상을 위해 Plugin cache 사용  '~/.bashrc'  Path 내 하기 구문 기입
    $ export TF_PLUGIN_CACHE_DIR=/opt/terraform-plugin-dir
```

### Run it locally

```shell

$ terraform cache install
#init provider & install plugin

$ terraform init

$ terraform plan

$ terraform apply
 ```

## Code Tree
``` 

Common
 ├── IAM_policy
 ├── IAM_Role
 ├── VPC Resource
 

INFRA
 ├── EKS
    ├── subnet
    ├── EKS Cluster / Worker Nodes 
 ├── Rancher
     ├── cluster
 ├── ElastiCache
 ├── RDS

DEV
 ├── EKS
    ├── subnet
    ├── EKS Cluster / Worker Nodes 
 ├── Rancher
     ├── cluster
 ├── ElastiCache
 ├── RDS

PROD
 ├── EKS
    ├── subnet
    ├── EKS Cluster / Worker Nodes 
 ├── Rancher
     ├── cluster
 ├── ElastiCache (redis)
 ├── RDS

```

