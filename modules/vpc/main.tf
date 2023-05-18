terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.2.0"
}

locals {
    allow_all_access_block = "0.0.0.0/0"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "Main VPC"
    Environment = "${var.environment_tag}"
  }
}

# Subnet
resource "aws_subnet" "public" {
  count                   = length(var.public_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "Public Subnet"
    Environment = var.environment_tag
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "Private Subnet"
    Environment = var.environment_tag
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "Main VPC"
    Environment = var.environment_tag
  }
}

# Route Table
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = local.allow_all_access_block
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Environment = var.environment_tag
  }
}

resource "aws_route_table_association" "rta_subnet_public" {
  count          = length(var.public_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table" "rtb_private" {
  vpc_id = aws_vpc.main.id
  route  = []
  tags = {
    Environment = var.environment_tag
  }
}

resource "aws_route_table_association" "rta_subnet_private" {
  count          = length(var.private_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rtb_private.id
}
