#-------------------------------------------------------------
# Create VPC / IGW / NAT GW
#-------------------------------------------------------------

resource "aws_vpc" "vpc" {

  enable_dns_support = true
  enable_dns_hostnames = true
  cidr_block = var.vpc_cidr
  tags = {
      Name = upper("vpc-${var.env}")
  }
}

# Create Internet Gateway (For Public Subnet)
resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.vpc.id
  tags = {
      Name = upper("igw-${var.env}")
  }
}