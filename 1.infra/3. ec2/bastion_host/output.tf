#--------------------------------------------------------------
# Output EC2 Instance
#--------------------------------------------------------------

#BastionHost
output "bastion_host_instance" {value = module.bastion_host.ec2_instance}
