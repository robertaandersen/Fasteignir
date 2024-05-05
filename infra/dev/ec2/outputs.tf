output "subnets" {
  value = var.subnets
}

output "http_security_group_id" {
  value = aws_security_group.allow_http.id
}

output "ec2_instance_ids" {
  value = module.ec2.*.ec2_instance_id
}