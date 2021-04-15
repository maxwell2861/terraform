# Common Resource 


> Terraform Provisioning for Common Resource


**Table of Contents**  
- [Release Notes](#relese-note)
- [Terraform Provisionig File List](#run-terraform-command-with-tf-file)
  - [iam](#iam.tf)
  - [s3](#s3.tf)



## Release Notes

```
2020-10-27
- 

2020-10-15
- Common Resource Code 정리

```

  
## main.tf


**Infra Network**
| **Name**  | **Description** |
|-----------------|-------------------------|
|VPC |	10.255.0.0/16|
|IGW |	O|



**Dev Network**
| **Name**  | **Description** |
|-----------------|-------------------------|
|VPC |	192.168.0.0/16|
|IGW |	O|

**Production Network**
| **Name**  | **Description** |
|-----------------|-------------------------|
|VPC	|10.1.0.0/16|
|IGW  |	O|