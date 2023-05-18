output "main_vpc_id" {
  description = "Main VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "ID of public subnets"  
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "ID of private subnets"
  value       = aws_subnet.private[*].id
}