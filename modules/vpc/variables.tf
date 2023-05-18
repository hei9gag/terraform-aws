variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "public_cidr_blocks" {
    description = "CIDR blocks for public subnet"
    type = list(string)
}

variable "private_cidr_blocks" {
    description = "CIDR blocks for private subnet"
    type = list(string)
}

variable "availability_zones" {
    type = list(string)
}

variable "environment_tag" {
  description = "Environment Tag"
  default     = "Dev"
}
