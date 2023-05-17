terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Create S3 Bucket
# module "aws-s3" {
#   source = "./modules/aws-s3"

#   bucket_name = "chbr-s3-playground-hk"

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

locals {
  allow_all_access_block = "0.0.0.0/0"

  public_cidr_blocks = [
    "10.1.0.0/24",
    "10.1.1.0/24"
  ]

  private_cidr_blocks = [
    "10.1.16.0/20",
    "10.1.32.0/20"
  ]

  availability_zones = [
    "ap-east-1a",
    "ap-east-1b",
  ]
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
  count                   = length(local.public_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_cidr_blocks[count.index]
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "Public Subnet"
    Environment = "${var.environment_tag}"
  }
}

resource "aws_subnet" "private" {
  count             = length(local.private_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_cidr_blocks[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = {
    Name        = "Private Subnet"
    Environment = "${var.environment_tag}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "Main VPC"
    Environment = "${var.environment_tag}"
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
  count          = length(local.public_cidr_blocks)
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
  count          = length(local.private_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rtb_private.id
}

# Security group
resource "aws_security_group" "default_sg" {
  name   = "default_sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.environment_tag
  }
}

resource "aws_key_pair" "ec2key" {
  key_name   = "publicKey"
  public_key = file(var.public_key_path)
}

# Create EC 2 instance
# resource "aws_instance" "test_instance" {
#   ami                    = var.instance_ami
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.public[0].id
#   vpc_security_group_ids = ["${aws_security_group.default_sg.id}"]
#   key_name               = aws_key_pair.ec2key.key_name
#   tags = {
#     Environment = "${var.environment_tag}"
#   }
# }