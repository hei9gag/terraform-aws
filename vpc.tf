module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name = "main-vpc"

  cidr = local.vpc.cidr_vpc
  azs  = local.vpc.availability_zones

  private_subnets = local.vpc.private_cidr_blocks
  public_subnets  = local.vpc.public_cidr_blocks

  # enable_nat_gateway   = true
  # single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    Name        = "Public Subnet"
    Environment = var.environment_tag
  }

  private_subnet_tags = {
    Name        = "Private Subnet"
    Environment = var.environment_tag
  }
}