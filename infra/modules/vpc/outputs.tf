output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "Public subnets."
  value       = aws_subnet.public_subnets
}
output "private_subnets" {
  description = "Private subnets."
  value       = aws_subnet.private_subnets
}

output "allow_ssh_sg_security_group_id" {
  description = "The ID of the security group."
  value       = aws_security_group.allow_ssh_sg.id

}

