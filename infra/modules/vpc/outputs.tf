output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "The IDs of the subnets."
  value       = concat(aws_subnet.public_subnets.*.id, aws_subnet.private_subnets.*.id)
}



