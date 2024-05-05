output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "allow_ssh_sg_security_group_id" {
  value = module.vpc.allow_ssh_sg_security_group_id
}

