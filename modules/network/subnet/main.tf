data "aws_region" "current" {}

locals {
  service_az_info =  [ "a","c" ]
  subnet_num = {
    
    pub     = [1,2]
    pri     = [101,102,103,104]
    data    = [11,12]
    db      = [201,202]
    privacy = [210,211]
    
    }
  
  subnet_cidr = {
    pub       =  [for subnet in local.subnet_num.pub : cidrsubnet(var.vpc_cidr, 8 , subnet)]
    pri       =  [for subnet in local.subnet_num.pri : cidrsubnet(var.vpc_cidr, 8 , subnet)]
    data      =  [for subnet in local.subnet_num.data : cidrsubnet(var.vpc_cidr, 8 , subnet)]
    db        =  [for subnet in local.subnet_num.db : cidrsubnet(var.vpc_cidr, 8 , subnet)]
    privacy   =  [for subnet in local.subnet_num.privacy : cidrsubnet(var.vpc_cidr, 8 , subnet)]
  }
  subnet_index = {
    a_zone = [aws_subnet.pri_subnet[0].id,aws_subnet.db_subnet[0].id,aws_subnet.data_subnet[0].id,aws_subnet.pri_subnet[2].id ]
    c_zone = [aws_subnet.pri_subnet[1].id,aws_subnet.db_subnet[1].id,aws_subnet.data_subnet[1].id,aws_subnet.pri_subnet[3].id ]
  
  }
  region_az   = [for info in local.service_az_info : "${local.region_id}${info}"]
  region_id   = data.aws_region.current.name
  eks_tags = {
  for name in var.eks_cluster_name:
      "kubernetes.io/cluster/${name}" => "shared"
  }

}


# Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  count = length(local.subnet_cidr.pub)
  allocation_id = element(aws_eip.nat.*.id,count.index)
  subnet_id     = element(aws_subnet.pub_subnet.*.id, count.index)
  tags = {
    Name = "${var.env}-nat-${format("%02d",count.index+1)}${substr(element(local.region_az,count.index),-1,1)}"
    
  }
}



# Create NAT EIP
resource "aws_eip" "nat" {
  count    = length(local.subnet_cidr.pub)
  vpc      = true
  tags = {
    Name   = "${var.env}-nat-eip-${format("%02d",count.index+1)}${substr(element(local.region_az,count.index),-1,1)}"
  }
}

#-----------------------------------------------------------------------------
# Create  Subnet [ PUB | PRI | DB | AWS]
#-----------------------------------------------------------------------------

# Create Public Subnet
  resource "aws_subnet" "pub_subnet" {
  count = length(local.subnet_cidr.pub)
  
  vpc_id                  = var.vpc_id
  cidr_block              = element(local.subnet_cidr.pub,count.index)
  availability_zone       = element(local.region_az,count.index)
  map_public_ip_on_launch = true
  tags = merge(
    local.eks_tags,
    map("Name", "${var.env}-pub-${format("%02d",count.index+1)}${substr(element(local.region_az,count.index),-1,1)}"
   ))
  }


# Create Private Subnet
resource "aws_subnet" "pri_subnet" {
  count = length(local.subnet_cidr.pri)
  vpc_id                  = var.vpc_id
  cidr_block              = element(local.subnet_cidr.pri,count.index)
  availability_zone       = element(local.region_az,count.index)
  map_public_ip_on_launch = false
  tags = merge(
    local.eks_tags,
    map("Name", "${var.env}-pri-${format("%02d",count.index+1)}${substr(element(local.region_az,count.index),-1,1)}"
   ))
}

# Create DB Subnet
resource "aws_subnet" "db_subnet" {
  count = length(local.subnet_cidr.db)
  vpc_id                  = var.vpc_id
  cidr_block              = element(local.subnet_cidr.db,count.index)
  availability_zone       = element(local.region_az,count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-db-${format("%02d",count.index+1)}${substr(element(local.region_az,count.index),-1,1)}" 
  }
}

# Create Data Subnet
resource "aws_subnet" "data_subnet" {
  count = length(local.subnet_cidr.data)
  vpc_id                  = var.vpc_id
  cidr_block              = element(local.subnet_cidr.data,count.index)
  availability_zone       = element(local.region_az,count.index)
  map_public_ip_on_launch = false
  tags = {
    Name ="${var.env}-data-${format("%02d",count.index+1)}${substr(element(local.region_az,count.index),-1,1)}"
    }
}

# Create privacy Subnet
resource "aws_subnet" "privacy_subnet" {
  count                   = var.env == "prod" ? length(local.subnet_cidr.privacy) : 0
  vpc_id                  = var.vpc_id
  cidr_block              = element(local.subnet_cidr.privacy,count.index)
  availability_zone       = element(local.region_az,count.index)
  map_public_ip_on_launch = false
  tags = {
    Name =  "${var.env}-privacy-${format("%02d",count.index+1)}${substr(element(local.region_az,count.index),-1,1)}"
  }
}


#-----------------------------------------------
# DB Subnet Group
#-----------------------------------------------

resource "aws_db_subnet_group" "db" {
  name       = "${var.env}-db-subnet-group"
  description = "For ${var.env} Network RDS Subnet Group"
  subnet_ids = aws_subnet.db_subnet.*.id
   tags = {
    Name = "${var.env}-db-subnet-group"
  }
}

#-----------------------------------------------
# Privacy Subnet Group
#-----------------------------------------------

resource "aws_db_subnet_group" "privacy" {
  count      = var.env == "prod" ? 1 : 0 
  name       = "${var.env}-privacy-subnet-group"
  description = "${var.env}-privacy-subnet-group"
  subnet_ids = aws_subnet.privacy_subnet.*.id
   tags = {
    Name = "${var.env}-privacy-subnet-group"
  }
}

#-----------------------------------------------
# Cache Subnet Group
#-----------------------------------------------

resource "aws_elasticache_subnet_group" "db" {
  name       = "${var.env}-cache-subnet-group"
  description = "For ${var.env} Network Redis Subnet Group"
  subnet_ids = aws_subnet.db_subnet.*.id
}


#-----------------------------------------------------------------------------
# Set Route table  [ PUB | PRI | DB  | AWS]
#-----------------------------------------------------------------------------

# Set Route table [Public] 
  resource "aws_route_table" "public" {
    vpc_id = var.vpc_id
    lifecycle {
      ignore_changes = [route]
    }
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = var.igw_id
    }
    tags = {
      Name = "${var.env}-pub-rtb"
    }
}

# Set Route table [Private]
  resource "aws_route_table" "private" {
    count = length(local.subnet_cidr.pub)
    vpc_id = var.vpc_id
    lifecycle {
      ignore_changes = [route]
    }
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = element(aws_nat_gateway.nat.*.id,count.index)
    }
    tags = {
      Name  = "${var.env}-nat-rtb-${format("%02d",count.index+1)}${substr(element(local.region_az,count.index),-1,1)}"
      
      #Name = "${var.env}-nat-${substr(element(local.region_az,count.index),-2,2)}-rtb"
    }
  }

  # Set Route table [Private]
  resource "aws_route_table" "privacy" {
    count = var.env == "prod" ? length(local.subnet_cidr.privacy) : 0
    vpc_id = var.vpc_id
    lifecycle {
      ignore_changes = [route]
    }
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = element(aws_nat_gateway.nat.*.id,count.index)
    }
    tags = {
      Name  = "${var.env}-privacy-rtb-${format("%02d",count.index+1)}${substr(element(local.region_az,count.index),-1,1)}"
      #Name = "${var.env}-nat-${substr(element(local.region_az,count.index),-2,2)}-rtb"
    }
  }

# Set Routetable Association (For PUB | PRI | DB | Data)

  resource "aws_route_table_association" "pub_route_table" {
  count          = length(local.subnet_cidr.pub)
  subnet_id      = element(aws_subnet.pub_subnet.*.id,count.index)
  route_table_id = aws_route_table.public.id
  }

  resource "aws_route_table_association" "pri_a_table" {
  count          = length(local.subnet_cidr.pri)
  subnet_id      = element(local.subnet_index.a_zone,count.index)
  route_table_id = aws_route_table.private.0.id
  }

  resource "aws_route_table_association" "pri_c_table" {
  count          = length(local.subnet_cidr.pri)
  subnet_id      = element(local.subnet_index.c_zone,count.index)
  route_table_id = aws_route_table.private.1.id
  }

  resource "aws_route_table_association" "privacy" {
  lifecycle {ignore_changes = [route_table_id]}
  count          = var.env == "prod" ? length(local.subnet_cidr.privacy) : 0
  subnet_id      = element(aws_subnet.privacy_subnet.*.id,count.index)
  route_table_id = element(aws_route_table.privacy.*.id,count.index)
  }



#---------------------------------------------------------------------------
# Create S3 endpoint
#---------------------------------------------------------------------------

resource "aws_vpc_endpoint" "service_s3" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.${local.region_id}.s3"
  vpc_endpoint_type = "Gateway"
  tags = {
      Name = "${var.env}-s3-endpoint"
    }
}

# Set Routetable Association (For s3 endpoint)
resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count           = length(local.subnet_cidr.pub)
  vpc_endpoint_id = aws_vpc_endpoint.service_s3.id
  route_table_id  = element(aws_route_table.public.*.id,count.index)
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count           = length(local.subnet_cidr.pri)
  vpc_endpoint_id = aws_vpc_endpoint.service_s3.id
  route_table_id  = element(aws_route_table.private.*.id,count.index)
}

#---------------------------------------------------------------------------
# Create EC2 endpoint
#---------------------------------------------------------------------------
/*
resource "aws_security_group" "endpoint_ec2" {
  vpc_id = var.vpc_id
  name   = upper("${var.env}-test-ec2-endpoint")
  description = upper("${var.env}-test-ec2-endpoint")
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name   = upper("${var.env}-test-ec2-endpoint")
  }
}
  
resource "aws_vpc_endpoint" "service_ec2" {
  vpc_id = var.vpc_id
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  service_name = "com.amazonaws.${local.region_id}.ec2"
  security_group_ids = [aws_security_group.endpoint_ec2.id]
  tags = {
      Name = "${var.env}-ec2-endpoint"
    }
}

*/