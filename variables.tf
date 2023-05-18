variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-east-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

# Variables for VPC and EC 2
variable "public_key_path" {
  description = "Public key path"
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default     = "ami-0818314d9ae02af81"
}

variable "instance_type" {
  description = "type for aws EC2 instance"
  default     = "t3.micro"
}

variable "environment_tag" {
  description = "Environment Tag"
  default     = "Dev"
}