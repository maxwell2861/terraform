#--------------------------------------------
#
# IAM Group Policy 
# 1. MFA Policy
# 2. Set Password policy
# 3. ReadOnly KMS Policy
# 4. Frontend Developer Policy
# 5. Backend Developer Policy
#
#--------------------------------------------

#--------------------------------------------
# 1. MFA Policy
#--------------------------------------------

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "test_mfa_policy" {
  name = "Test_IAM_UserSetMFA_Policy"
  path = "/"
  description = "Provides the ability for an IAM user to manage their own MFA."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListActions",
            "Effect": "Allow",
            "Action": [
                "iam:ListUsers",
                "iam:ListVirtualMFADevices"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowIndividualUserToListOnlyTheirOwnMFA",
            "Effect": "Allow",
            "Action": [
                "iam:ListMFADevices"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/*",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowIndividualUserToManageTheirOwnMFA",
            "Effect": "Allow",
            "Action": [
                "iam:CreateVirtualMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:DeactivateMFADevice",
                "iam:ResyncMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/$${aws:username}",
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
            ]
        }
    ]
}
EOF
}

#--------------------------------------------
# 2. Set Password Policy
#--------------------------------------------
resource "aws_iam_policy" "test_passowrd_policy" {
  name = "Test_IAM_EachUserManagementOwn_Policy"
  path = "/"
  description = "Provides the ability for an IAM user to manage their own Password."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:ChangePassword",
            "Resource":"arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/$${aws:username}"
        },
        {
            "Effect": "Allow",
            "Action": "iam:GetAccountPasswordPolicy",
            "Resource": "*"
        }
    ]
}
EOF
}

#--------------------------------------------
# 3. KMS Readonly Policy
#--------------------------------------------
resource "aws_iam_policy" "test_kmsread_policy" {
  name = "Test_Kms_ReadOnlyAccess_Policy"
  path = "/"
  description = "Provides the ability for an IAM user to KMS Read Only Access."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "kms:ListKeyPolicies",
                "kms:GenerateRandom",
                "kms:ListRetirableGrants",
                "kms:GetKeyPolicy",
                "kms:ListResourceTags",
                "kms:ReEncryptFrom",
                "kms:ListGrants",
                "kms:GetParametersForImport",
                "kms:ListKeys",
                "kms:GetKeyRotationStatus",
                "kms:ListAliases",
                "kms:ReEncryptTo",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#--------------------------------------------
# 4. BackendDevelopers
#--------------------------------------------
resource "aws_iam_policy" "test_backenddevelopers_policy" {
  name = "Test_BackendDevelopers_Policy"
  path = "/"
  description = "BackendDevelopers Policy"
  
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "health:DescribeAffectedEntities",
                "rds:*",
                "route53:ListTrafficPolicyVersions",
                "logs:*",
                "route53:TestDNSAnswer",
                "route53:GetHostedZone",
                "route53:GetHealthCheck",
                "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
                "elasticbeanstalk:DescribeEnvironmentManagedActionHistory",
                "autoscaling:*",
                "route53:ListHostedZonesByName",
                "elasticbeanstalk:DescribeEnvironmentResources",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticbeanstalk:DescribeEnvironments",
                "logs:GetLogEvents",
                "route53:ListResourceRecordSets",
                "elasticloadbalancing:DescribeLoadBalancerPolicies",
                "elasticbeanstalk:DescribeApplicationVersions",
                "ec2messages:*",
                "route53:GetHostedZoneCount",
                "elasticloadbalancing:DescribeInstanceHealth",
                "route53:GetHealthCheckCount",
                "sns:*",
                "route53:ListReusableDelegationSets",
                "elasticbeanstalk:DescribePlatformVersion",
                "route53:GetHealthCheckLastFailureReason",
                "route53:ListTrafficPolicyInstancesByHostedZone",
                "route53:ListVPCAssociationAuthorizations",
                "route53:GetReusableDelegationSetLimit",
                "elasticbeanstalk:ListPlatformVersions",
                "route53:ListTagsForResources",
                "route53:GetAccountLimit",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticbeanstalk:DescribeEnvironmentManagedActions",
                "config:DescribeConfigurationRecorders",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "cloudwatch:*",
                "elasticbeanstalk:DescribeEvents",
                "route53:GetGeoLocation",
                "ec2:*",
                "route53:GetHostedZoneLimit",
                "elasticloadbalancing:DescribeRules",
                "route53:GetTrafficPolicy",
                "route53:ListTrafficPolicyInstances",
                "route53:GetTrafficPolicyInstanceCount",
                "route53:GetChange",
                "logs:DescribeLogStreams",
                "health:DescribeEventTypes",
                "elasticbeanstalk:ValidateConfigurationSettings",
                "elasticbeanstalk:CheckDNSAvailability",
                "route53:ListQueryLoggingConfigs",
                "health:DescribeEntityAggregates",
                "elasticbeanstalk:RequestEnvironmentInfo",
                "route53:GetCheckerIpRanges",
                "elasticloadbalancing:DescribeListeners",
                "health:DescribeEventAggregates",
                "route53:ListTrafficPolicies",
                "elasticbeanstalk:DescribeInstancesHealth",
                "elasticbeanstalk:DescribeEnvironmentHealth",
                "acm:ListCertificates",
                "route53:ListGeoLocations",
                "elasticbeanstalk:DescribeApplications",
                "route53:GetTrafficPolicyInstance",
                "health:DescribeEvents",
                "route53:GetQueryLoggingConfig",
                "elasticloadbalancing:DescribeSSLPolicies",
                "route53:GetHealthCheckStatus",
                "s3:*",
                "elasticloadbalancing:DescribeTags",
                "route53:ListHostedZones",
                "health:DescribeEventDetails",
                "route53:GetReusableDelegationSet",
                "elasticbeanstalk:DescribeConfigurationSettings",
                "route53:ListTagsForResource",
                "support:*",
                "elasticbeanstalk:ListAvailableSolutionStacks",
                "route53:ListTrafficPolicyInstancesByPolicy",
                "route53:ListHealthChecks",
                "elasticbeanstalk:DescribeConfigurationOptions",
                "ssm:*",
                "elasticloadbalancing:DescribeTargetHealth",
                "lambda:*",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticache:*",
                "elasticbeanstalk:RetrieveEnvironmentInfo"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "apigateway:*",
            "Resource": "arn:aws:apigateway:*::/*"
        },
        {
            "Effect": "Deny",
            "Action": [
                "ec2:DeleteSubnet",
                "ec2:DeleteVpcEndpoints",
                "ec2:DeleteVpcPeeringConnection",
                "ec2:DeleteRoute",
                "route53:DeleteHostedZone",
                "ec2:DetachInternetGateway",
                "ec2:DeleteVpc",
                "ec2:DisassociateRouteTable",
                "ec2:DeleteRouteTable"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Deny",
            "Action": "s3:DeleteObject",
            "Resource": [
                "arn:aws:s3:::test-comics/*",
                "arn:aws:s3:::test-inventories/*",
                "arn:aws:s3:::test-novels/*",
                "arn:aws:s3:::test-posts/*",
                "arn:aws:s3:::test-common/*"
            ]
        },
        {
            "Effect": "Deny",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::test-geofront-masterkey/*",
                "arn:aws:s3:::test-geofront-masterkey"
            ]
        }
    ]
}
EOF
}

#--------------------------------------------
# 5. Frontend Devlopers
#--------------------------------------------
resource "aws_iam_policy" "test_frontenddevelopers_policy" {
  name = "Test_FrontendDevelopers_Policy"
  path = "/"
  description = "FrontendDevelopers Policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Action": "elasticache:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "opsworks:*",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeLoadBalancers",
                "iam:GetRolePolicy",
                "iam:ListInstanceProfiles",
                "iam:ListRoles",
                "iam:ListUsers",
                "iam:PassRole"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticbeanstalk:*",
                "ec2:*",
                "ecs:*",
                "ecr:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "dynamodb:*",
                "rds:*",
                "sqs:*",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:PassRole",
                "iam:ListRolePolicies",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfiles",
                "iam:ListRoles",
                "iam:ListServerCertificates",
                "acm:DescribeCertificate",
                "acm:ListCertificates"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:AddRoleToInstanceProfile",
                "iam:CreateInstanceProfile",
                "iam:CreateRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/aws-elasticbeanstalk*",
                "arn:aws:iam::*:instance-profile/aws-elasticbeanstalk*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:AttachRolePolicy"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "iam:PolicyArn": [
                        "arn:aws:iam::aws:policy/AWSElasticBeanstalk*",
                        "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalk*"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "apigateway:*"
            ],
            "Resource": "arn:aws:apigateway:*::/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Deny",
            "Action": [
                "route53:DeleteHostedZone"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:PutRetentionPolicy"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}



#--------------------------------------------
# IAM Role Policy 
# 1. EKS Ingress Policy
#--------------------------------------------


#--------------------------------------------
# 1. EKS Ingress Policy
#--------------------------------------------
resource "aws_iam_policy" "test_eksingress_policy" {
  name = "Test_EKS_Ingress_Policy"
  path = "/"
  description = "EKS Ingress Policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "acm:DescribeCertificate",
                "acm:ListCertificates",
                "acm:GetCertificate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DeleteSecurityGroup",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVpcs",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateRule",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DeleteRule",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:ModifyRule",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:RemoveListenerCertificates",
                "elasticloadbalancing:RemoveTags",
                "elasticloadbalancing:SetIpAddressType",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:SetSubnets",
                "elasticloadbalancing:SetWebACL"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole",
                "iam:GetServerCertificate",
                "iam:ListServerCertificates"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetWebACLForResource",
                "waf-regional:GetWebACL",
                "waf-regional:AssociateWebACL",
                "waf-regional:DisassociateWebACL"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "tag:GetResources",
                "tag:TagResources"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "waf:GetWebACL"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}



