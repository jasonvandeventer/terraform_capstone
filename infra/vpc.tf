resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "capstone-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_az1
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "capstone-public-subnet-az1"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_az2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "capstone-public-subnet-az2"
  }
}

# Private Subnets
resource "aws_subnet" "private_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_az1
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = false

  tags = {
    Name = "capstone-private-subnet-az1"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_az2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = false

  tags = {
    Name = "capstone-private-subnet-az2"
  }
}

# Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "capstone-igw"
  }
}

# NAT Gateway for private subnets
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "capstone-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_az1.id

  tags = {
    Name = "capstone-nat-gateway"
  }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "capstone-public-rt"
  }
}

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "capstone-private-rt"
  }
}

resource "aws_route_table_association" "private_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_az2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private.id
}

