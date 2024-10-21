

# Tạo VPC
resource "aws_vpc" "first_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Tạo Internet Gateway cho VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.first_vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Tạo Public Subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id            = aws_vpc.first_vpc.id
  cidr_block        = var.public_subnet_az1_cidrs
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az1"
  }
}


# Tạo Private Subnet az1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id            = aws_vpc.first_vpc.id
  cidr_block        = var.private_subnet_az1_cidrs
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "private subnet az1"
  }
}

# Tạo Default Security Group
resource "aws_security_group" "default" {
  vpc_id = aws_vpc.first_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-default-sg"
  }
}

# Lấy thông tin về các Availability Zones có sẵn
data "aws_availability_zones" "available" {
  state = "available"
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.first_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Gán Route Table Public với Public Subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public.id
}




