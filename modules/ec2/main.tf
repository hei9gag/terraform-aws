terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.2.0"
}


resource "aws_key_pair" "ec2key" {
  key_name   = "publicKey"
  public_key = file(var.public_key_path)
}

# Create EC 2 instance
resource "aws_instance" "playground" {
  count = var.should_create_ec2 ? 1 : 0
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = aws_key_pair.ec2key.key_name
  tags = {
    Environment = var.environment_tag
  }
}