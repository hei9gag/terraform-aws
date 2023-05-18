output "default_sg_id" {
  description = "ID for default security group"
  value       = aws_security_group.default_sg.id
}
