
# Variables
variable "vpc_cidr" {}
variable "public_subnet" {}
variable "private_subnet" {}
variable "az" {}


# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "customvpc" }
}

# Public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet
  map_public_ip_on_launch = true
  availability_zone       = var.az
  tags = { Name = "shashank-puppala-public" }
}

# Private subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet
  availability_zone = var.az
  tags = { Name = "shashank-puppala-private" }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "customvpc-igw" }
}

# Elastic IP for NAT
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "nat-eip" }
}

# NAT Gateway in public subnet
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.this]
  tags          = { Name = "customvpc-natgw" }
}

# Public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = { Name = "customvpc-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Private route table with NAT Gateway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = { Name = "customvpc-private-rt" }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}


# Outputs

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

