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

locals {
  vpc = {
    cidr_vpc = "10.1.0.0/16"
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

  ec2 = {
    public_key_path = "~/.ssh/id_rsa.pub"
    instance_ami    = "ami-0818314d9ae02af81"
    instance_type   = "t3.micro"
    should_create   = false # Update the value to true to create / update ec 2 instance
  }

  environment_tag = "Dev"
}

module "vpc" {
  source              = "./modules/vpc"
  cidr_vpc            = local.vpc.cidr_vpc
  public_cidr_blocks  = local.vpc.public_cidr_blocks
  private_cidr_blocks = local.vpc.private_cidr_blocks
  availability_zones  = local.vpc.availability_zones
  environment_tag     = local.environment_tag
}

module "security_group" {
  source            = "./modules/security-group"
  default_sg_vpc_id = module.vpc.main_vpc_id
  environment_tag   = local.environment_tag
}

module "ec2" {
  source                 = "./modules/ec2"
  public_key_path        = local.ec2.public_key_path
  instance_ami           = local.ec2.instance_ami
  instance_type          = local.ec2.instance_type
  subnet_id              = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [module.security_group.default_sg_id]
  environment_tag        = local.environment_tag
  should_create_ec2      = local.ec2.should_create
}