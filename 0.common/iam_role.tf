
#--------------------------------------------------------
# IAM Group
#--------------------------------------------------------

#------------------------------------------------------
# Devops Group
#------------------------------------------------------

resource "aws_iam_group" "test_devops" {
  name = "Test_Devops_Group"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "test_devops" {
  group = aws_iam_group.test_devops.name
  count = length(local.devops_policy_arn)
  policy_arn = local.devops_policy_arn[count.index]
}

#------------------------------------------------------
# Developer Group
#------------------------------------------------------

resource "aws_iam_group" "test_developers" {
  name = "Test_Developers_Group"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "test_developers_policy" {
  group = aws_iam_group.test_developers.name
  count = length(local.developers_policy_arn)
  policy_arn = local.developers_policy_arn[count.index]
}

#Custom Policy Mount [MFA]
resource "aws_iam_group_policy_attachment" "test_developers_mfa" {
  group = aws_iam_group.test_developers.name
  policy_arn = aws_iam_policy.test_mfa_policy.arn
}
#Custom Policy Mount [Password]
resource "aws_iam_group_policy_attachment" "test_developers_password" {
  group = aws_iam_group.test_developers.name
  policy_arn = aws_iam_policy.test_passowrd_policy.arn
}
#Custom Policy Mount [KMS]
resource "aws_iam_group_policy_attachment" "test_developers_kms" {
  group = aws_iam_group.test_developers.name
  policy_arn = aws_iam_policy.test_kmsread_policy.arn
}

#------------------------------------------------------
# Deploy Group
#------------------------------------------------------

resource "aws_iam_group" "test_deploy" {
  name = "Test_Deploy_Group"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "test_deploy_policy" {
  group = aws_iam_group.test_deploy.name
  count = length(local.deploy_policy_arn)
  policy_arn = local.deploy_policy_arn[count.index]
}

#Custom Policy Mount [BackendDeveloper]
resource "aws_iam_group_policy_attachment" "test_deploy_backend" {
  group = aws_iam_group.test_deploy.name
  policy_arn = aws_iam_policy.test_backenddevelopers_policy.arn
}
#Custom Policy Mount [FrontendDeveloper]
resource "aws_iam_group_policy_attachment" "test_deploy_frontend" {
  group = aws_iam_group.test_deploy.name
  policy_arn = aws_iam_policy.test_frontenddevelopers_policy.arn
}

#Custom Policy Mount [KMS]
resource "aws_iam_group_policy_attachment" "test_deploy_kmsread" {
  group = aws_iam_group.test_deploy.name
  policy_arn = aws_iam_policy.test_kmsread_policy.arn
}


#------------------------------------------------------
# Application Group
#------------------------------------------------------

resource "aws_iam_group" "test_application" {
  name = "Test_Application_Group"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "test_application_policy" {
  group = aws_iam_group.test_application.name
  count = length(local.application_policy_arn)
  policy_arn = local.application_policy_arn[count.index]
}


#------------------------------------------------------
# SecurityAdministrator Group
#------------------------------------------------------

resource "aws_iam_group" "test_securityadmin" {
  name = "Test_SecurityAdmin_Group"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "test_securityadmin_policy" {
  group = aws_iam_group.test_securityadmin.name
  count = length(local.securityadmin_policy_arn)
  policy_arn = local.securityadmin_policy_arn[count.index]
}

#Custom Policy Mount [MFA]
resource "aws_iam_group_policy_attachment" "test_securityadmin_mfa" {
  group = aws_iam_group.test_securityadmin.name
  policy_arn = aws_iam_policy.test_mfa_policy.arn
}


#--------------------------------------------------------
#
# IAM Role
#
#--------------------------------------------------------


#------------------------------------------------------
# EC2 Role / Profile
#------------------------------------------------------

resource "aws_iam_role" "role_ec2" {
  name = "Test_EC2_Instance_Role"
  path = "/"
  description = "test EC2 Default Role"
  max_session_duration = 3600
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ssm.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_instance_profile" "ec2_profile" {
name = "Test_EC2_Role_Profile"
role = aws_iam_role.role_ec2.name
}

#-------------------------------------------------
# EC2_Role Policy Attach [Amazon ManagedRole]
#-------------------------------------------------
resource "aws_iam_role_policy_attachment" "test_ec2_policy" {
  role = aws_iam_role.role_ec2.name
  count = length(local.ec2_policy_arn)
  policy_arn = local.ec2_policy_arn[count.index]
}



#---------------------------------------------------
# EKS Cluster IAM Role / Profile
#----------------------------------------------------

resource "aws_iam_role" "role_eks_cluster" {
  name = "Test_EKS_Cluster_Role"
    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment"  "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.role_eks_cluster.name
}

resource "aws_iam_role_policy_attachment"  "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.role_eks_cluster.name
}

resource "aws_iam_role_policy_attachment"  "eks_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.role_eks_cluster.name
}

resource "aws_iam_instance_profile" "eks_cluster_profile" {
  name = "Test_EKS_Cluster_Role_Profile"
  role = aws_iam_role.role_eks_cluster.name
}



#---------------------------------------------------
# EKS Worker Node IAM Role
#----------------------------------------------------

resource "aws_iam_role" "role_eks_worker_node" {
  name = "Test_EKS_Worker_Node_Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "eks.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_instance_profile" "eks_worker_node_profile" {

  name = "Test_EKS_Worker_Node_Role_Profile"
  role = aws_iam_role.role_eks_worker_node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.role_eks_worker_node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.role_eks_worker_node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.role_eks_worker_node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.role_eks_worker_node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-alb-ingress_policy" {
  policy_arn = aws_iam_policy.test_eksingress_policy.arn
  role       = aws_iam_role.role_eks_worker_node.name
}
