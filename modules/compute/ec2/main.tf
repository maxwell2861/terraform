
resource "aws_instance" "ec2" {
    count                = var.ec2_count
    ami                  = var.ami
    instance_type        = var.instance_type
    subnet_id            = element(var.subnet,count.index)
    iam_instance_profile = var.iam_profile
    security_groups      = var.sg
    key_name             = var.ec2_key
    associate_public_ip_address = false
    user_data = element(data.template_file.userdata.*.rendered,count.index)
    ebs_optimized       = true    

  lifecycle {
                ignore_changes = [ami,user_data,security_groups,tags,ebs_optimized]
            }
  
   tags = {
            Name    = var.server_name
            env     = var.env
            os      = "amazon"
            role    = var.tag_role
          }
  volume_tags = {
            Name   = var.server_name
          }

  }

#Userdata Render
data "template_file" "userdata" {
  template  = var.userdata
  count     = var.ec2_count
  vars = {
    server_name = var.server_name
  }

}
