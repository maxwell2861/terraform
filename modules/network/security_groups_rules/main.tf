#-------------------------------------------------------------
# Create Security_Groups
#-------------------------------------------------------------
resource "aws_security_group_rule" "ingress_security_groups" {
  for_each = var.sg_rules
  
  type                     = "ingress"
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = each.value.protocol
  description              = each.value.desc
  source_security_group_id = each.value.source_sg_id
  security_group_id        = var.sg_id
}



