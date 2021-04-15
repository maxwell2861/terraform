
#--------------------------------------------
# EKS Cluster
#--------------------------------------------

resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = var.eks_cluster_role
  version  = var.eks_cluster_version
  vpc_config {
    security_group_ids      = [var.eks_cluster_sg_id,aws_security_group.eks_cluster.id]
    subnet_ids              = var.cluster_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }
  tags = {
    Name        = var.eks_cluster_name
    Environment = split("-",var.eks_cluster_name)[0]
    Role        = split("-",var.eks_cluster_name)[2]
  }
}

#--------------------------------------------
# EKS NodeGroup
#--------------------------------------------

resource "aws_eks_node_group" "main" {
  lifecycle { 
    create_before_destroy = false
    ignore_changes        = [scaling_config[0].desired_size]
  }
    cluster_name     = aws_eks_cluster.main.id
    node_group_name  = "${var.eks_cluster_name}-node"
    node_role_arn    = var.eks_node_group_role
    subnet_ids       = var.worker_node_subnets
    ami_type         = "AL2_x86_64"
    #instance_types   = [var.eks_node_type]
    version          = var.eks_cluster_version
  

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

 launch_template{
    id      = aws_launch_template.eks.id
    version = aws_launch_template.eks.latest_version
  }
  tags = {
    Name = "${var.eks_cluster_name}-node"
    Environment = split("-",var.eks_cluster_name)[0]
    Role        = split("-",var.eks_cluster_name)[2]
  }
}

resource "aws_launch_template" "eks" {
  name = "${var.eks_cluster_name}_node_lauch_teamplate"
  description = "${var.eks_cluster_name}_node launch teamplte"
  block_device_mappings {
    device_name = "/dev/xvda"

  ebs {
      volume_size = 80
      volume_type = "gp3"
    }
  }
  
  instance_type = var.eks_node_type

  key_name = var.ssh_key
 
  #Security Groups
  vpc_security_group_ids = [var.eks_node_sg_id,aws_security_group.eks_worker_node.id]
 
 
  monitoring {
    enabled = true
  }
/*
  network_interfaces {
    associate_public_ip_address = false
  }
*/
  #Tags
  tag_specifications{
   resource_type = "instance"
   tags = {
      Name = "${var.eks_cluster_name}-node"
      os   = "amazon"
      env  = var.env
      }
  }
  tag_specifications{
   resource_type = "volume"
   tags = {
      Name = "${var.eks_cluster_name}-node"
      }
  }
  #Userdata
  user_data = base64encode(data.template_file.userdata.rendered)
}

data "template_file" "userdata" {
  template = var.user_data
  vars = {
        server_name = "${var.eks_cluster_name}-node"
  }
}

#-----------------------------------------------
# EKS Cluster Security Groups
#-----------------------------------------------

resource "aws_security_group" "eks_cluster" {
  name        = "${var.eks_cluster_name}-sg"
  description = "${var.eks_cluster_name} communication with Worker Nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.eks_cluster_name}-cluster-sg"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

#EKS Cluster Inbound Setting
resource "aws_security_group_rule" "eks_cluster_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_worker_node.id
  to_port                  = 443
  type                     = "ingress"
}



#-----------------------------------------------
# EKS Worker Security Groups
#-----------------------------------------------
resource "aws_security_group" "eks_worker_node" {
  name        = "${var.eks_cluster_name}-node-sg"
  description = "${var.eks_cluster_name}-node communication with Worker Nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.eks_cluster_name}-node-sg"
    "kubernetes.io/cluster/${var.eks_cluster_name}-node" = "owned"
  }
}

resource "aws_security_group_rule" "eks_worker_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_worker_node.id
  source_security_group_id = aws_security_group.eks_worker_node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_worker_node.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}


#-----------------------------------------------
# AutoScaling Policy [CPU Utilization]
#-----------------------------------------------
/*
#Scale up alarm
resource "aws_autoscaling_policy" "high-cpu-policy" {
name = "${var.eks_cluster_name}-node-high-cpu-policy"
autoscaling_group_name = aws_eks_node_group.main.resources[0]["autoscaling_groups"][0]["name"]
adjustment_type = "ChangeInCapacity"
scaling_adjustment = "1"
cooldown = "300"
policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "high-cpu-alarm" {
alarm_name = "${var.eks_cluster_name}-node-cpu-alarm"
alarm_description = "${var.eks_cluster_name}-node-high-cpu-alarm"
comparison_operator = "GreaterThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "85"
dimensions = {
"AutoScalingGroupName" = aws_eks_node_group.main.resources[0]["autoscaling_groups"][0]["name"]
}
actions_enabled = true
alarm_actions = [aws_autoscaling_policy.high-cpu-policy.arn]
}

#Scale down alarm
resource "aws_autoscaling_policy" "low-cpu-policy" {
name = "${var.eks_cluster_name}-node-low-cpu-policy"
autoscaling_group_name = aws_eks_node_group.main.resources[0]["autoscaling_groups"][0]["name"]
adjustment_type = "ChangeInCapacity"
scaling_adjustment = "-1"
cooldown = "300"
policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "low-cpu-alarm" {
alarm_name = "${var.eks_cluster_name}-node-low-cpu-alarm"
alarm_description = "${var.eks_cluster_name}-node-low-cpu-alarm"
comparison_operator = "LessThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "5"
dimensions = {
"AutoScalingGroupName" = aws_eks_node_group.main.resources[0]["autoscaling_groups"][0]["name"]
}
actions_enabled = true
alarm_actions = [aws_autoscaling_policy.low-cpu-policy.arn]
}
*/