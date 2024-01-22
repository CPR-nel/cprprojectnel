# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block       = var.web_vpc_cidr
  instance_tenancy = var.web_vpc_tenancy
  enable_dns_hostnames = true 
  enable_dns_support = true

  tags = {
    Name = var.web_vpc_tags
  }
}




# Create public subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "app_ig" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "MyIGW"
  }
}



# Public Route Table
resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.main_vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_ig.id
  }

  tags = {
    Name = "public-route-table-1"
  }
}



# Public Route Table Association
resource "aws_route_table_association" "association" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.rtb-public.id
}




# Elastic IPs for NAT
resource "aws_eip" "web_eip" {
  count      = length(var.private_subnet_cidr_blocks)
  vpc        = true
  depends_on = [aws_internet_gateway.app_ig]

  tags = {
    Name = "eip-${count.index + 1}"
  }
}


# Create NAT Gateways
resource "aws_nat_gateway" "web_ngw" {
  count         = length(var.private_subnet_cidr_blocks)
  allocation_id = aws_eip.web_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "nat-gateway ${count.index + 1}"
  }
}


# Private Route Table
resource "aws_route_table" "rtb-private" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.web_ngw[count.index].id
  }

  tags = {
    Name = "private-route-table ${count.index + 1}"
  }
}


# Private Route Table Association
resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.rtb-private[count.index].id
}



# # Create public subnets
# resource "aws_subnet" "public_subnets" {
#   count             = length(var.public_subnet_cidr_blocks)
#   vpc_id            = aws_vpc.main_vpc.id
#   cidr_block        = var.public_subnet_cidr_blocks[count.index]
#   availability_zone = var.availability_zones[0]

#   tags = {
#     Name = "public-subnet-${count.index + 1}"
#   }
# }



# # Create Public Subnet 1
# resource "aws_subnet" "Public-Subnet-1" {
#   vpc_id     = aws_vpc.web-vpc.id
#   cidr_block = var.public_sid1
#   availability_zone = var.az1

#   tags = {
#     Name = var.public_sid1_name
#   }
# }


# # Internet Gateway
# resource "aws_internet_gateway" "web-igw" {
#   vpc_id = aws_vpc.web-vpc.id

#   tags = {
#     Name = "internet-gateway"
#   }
# }



# # Public Route table 1
# resource "aws_route_table" "rtb-public1" {
#   vpc_id = aws_vpc.web-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.web-igw.id
#   }

#   tags = {
#     Name = "public-route-table-1"
#   }
# }


# # Public Route Table 1 Association with Public Subnet
# resource "aws_route_table_association" "public1-rtba" {
#   subnet_id      = aws_subnet.Public-Subnet-1.id
#   route_table_id = aws_route_table.rtb-public1.id
# }


# # Create private subnets
# resource "aws_subnet" "private_subnets" {
#   count             = length(var.private_subnet_cidr_blocks)
#   vpc_id            = aws_vpc.main_vpc.id
#   cidr_block        = var.private_subnet_cidr_blocks[count.index]
#   availability_zone = var.availability_zones[count.index]

#   tags = {
#     Name = "private-subnet-${count.index + 1}"
#   }
# }


# # Create Private Subnet 1
# resource "aws_subnet" "Private-Subnet-1" {
#   vpc_id     = aws_vpc.web-vpc.id
#   cidr_block = var.private_sid1
#   availability_zone = var.az2

#   tags = {
#     Name = var.private_sid1_name
#   }
# }

# # Create Private Subnet 1
# resource "aws_subnet" "Private-Subnet-2" {
#   vpc_id     = aws_vpc.web-vpc.id
#   cidr_block = var.private_sid2
#   availability_zone = var.az3

#   tags = {
#     Name = var.private_sid2_name
#   }
# }


# # Elastic IP 1
# resource "aws_eip" "web-eip1" {
#   vpc               = true
#   depends_on        = [aws_internet_gateway.web-igw]
# }

# # Nat Gateway 1
# resource "aws_nat_gateway" "web-ngw1" {
#   allocation_id = aws_eip.web-eip1.id
#   subnet_id     = aws_subnet.Public-Subnet-1.id

#   tags = {
#     Name = "nat-gateway 1"
#   }
# }

# # Private Route table 1
# resource "aws_route_table" "rtb-private1" {
#   vpc_id = aws_vpc.web-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.web-ngw1.id
#   }

#   tags = {
#     Name = "private-route-table-1"
#   }
# }

# # private Route Table 1 Association with private Subnet
# resource "aws_route_table_association" "private1-rtba" {
#   subnet_id      = aws_subnet.Private-Subnet-1.id
#   route_table_id = aws_route_table.rtb-private1.id
# }