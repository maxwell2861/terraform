locals{
  eks_tags = {
  for name in var.eks_cluster_name:
      "kubernetes.io/cluster/${name}" => "owned"
  }
}

#-------------------------------------------------------------
# Create Security_Groups
#-------------------------------------------------------------

resource "aws_security_group" "sg" {
 name        = "${var.env}-${var.prefix}-${var.sg_name}-sg"
 lifecycle {ignore_changes = [description,ingress,egress]}
 vpc_id      = var.vpc_id
 description = var.sg_desc
 
dynamic "ingress" {
    for_each = var.sg_inbounds
    content {
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_block
      description     = ingress.value.desc
    }
  } 
  egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = merge(
    local.eks_tags,
    map("Name", "${var.env}-${var.prefix}-${var.sg_name}-sg"
    ))
   
}
