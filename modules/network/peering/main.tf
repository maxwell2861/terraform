
#--------------------------------------
# Peering
#--------------------------------------

# Peering [Infra]
resource "aws_vpc_peering_connection" "peering" {
  vpc_id = var.vpc_id
  peer_vpc_id = var.peer_vpc_id
  auto_accept = true
  tags = { 
    Name = upper("${var.env}-to-${var.peer_vpc_env}")
  }
}

# Peering [Temp]
resource "aws_vpc_peering_connection" "temp" {
  vpc_id = var.peer_vpc_id
  peer_vpc_id = "vpc-0618023532c933bf2"
  auto_accept = true
  tags = { 
    Name = upper("${var.peer_vpc_env}-to-infra-temp")
  }
}

#--------------------------------------------
# Peer Network
#--------------------------------------------

#Get Peer VPC CIDR
data "aws_vpc" "peer_vpc" {
  id = var.peer_vpc_id
}


#Get Peer Route Tables
data "aws_route_tables" "peer_rts" {
  vpc_id = var.peer_vpc_id
}

resource "aws_route" "peer_route" {
  for_each                  = data.aws_route_tables.peer_rts.ids
  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.infra_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}


#--------------------------------------------
# Infra Network
#--------------------------------------------

#Get VPC CIDR
data "aws_vpc" "infra_vpc" {
  id = var.vpc_id
}

#Get Route Tables
data "aws_route_tables" "infra_rts" {
  vpc_id = var.vpc_id
}

resource "aws_route" "infra_route" {
  for_each                  = data.aws_route_tables.infra_rts.ids
  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.peer_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}



#--------------------------------------------
# Temp Network
#--------------------------------------------

#Get VPC CIDR
data "aws_vpc" "temp_vpc" {
  id = "vpc-0618023532c933bf2"
}

#Get Route Tables
data "aws_route_tables" "temp_rts" {
  vpc_id = "vpc-0618023532c933bf2"
}


resource "aws_route" "temp_route" {
  for_each                  = data.aws_route_tables.temp_rts.ids
  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.peer_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.temp.id
}


resource "aws_route" "peer_temp_route" {
  for_each                  = data.aws_route_tables.peer_rts.ids
  route_table_id            = each.value
  destination_cidr_block    = "10.30.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.temp.id
}
