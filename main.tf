
data "aws_availability_zones" "available" {}

locals {
  vpc = {
    cidr_vpc = "10.1.0.0/16"
    public_cidr_blocks = [
      "10.1.0.0/24",
      "10.1.1.0/24",
      "10.1.2.0/24"
    ]
    private_cidr_blocks = [
      "10.1.16.0/20",
      "10.1.32.0/20",
      "10.1.48.0/20"
    ]
    availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
  }

  ec2 = {
    public_key_path = "~/.ssh/id_rsa.pub"
    instance_ami    = "ami-0818314d9ae02af81"
    instance_type   = "t3.micro"
    should_create   = false # Update the value to true to create / update ec 2 instance
  }
}


module "ec2" {
  source                 = "./modules/ec2"
  public_key_path        = local.ec2.public_key_path
  instance_ami           = local.ec2.instance_ami
  instance_type          = local.ec2.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.http_sg.id]
  environment_tag        = var.environment_tag
  should_create_ec2      = local.ec2.should_create
}
