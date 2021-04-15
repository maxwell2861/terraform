#--------------------------------------------------------------
# Output Stage EC2 Instance
#--------------------------------------------------------------

#game servers
output "game_instance" {value = module.stg-game.ec2_instance}
