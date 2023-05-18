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

variable "subnet_id" {
    description = "EC2 subnet Id"
    type = string
}

variable "vpc_security_group_ids" {
    type = list(string)
}

variable "should_create_ec2" {
    description = "To determine whther to create ec2 instance"
    type = bool
}

variable "environment_tag" {
  description = "Environment Tag"
  default     = "Dev"
}