#-----------------------------------------------
# Get Current Availability Zones
#-----------------------------------------------

data "aws_availability_zones" "az" {
  state = "available"
}

#-----------------------------------------------
# Get RDS Credentials
#-----------------------------------------------

data "aws_secretsmanager_secret_version" "creds" {
 secret_id = "hashicorp/terraform"
}
