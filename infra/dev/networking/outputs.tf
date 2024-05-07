output "vpc_id" {
  value = module.vpc.vpc_id
}
output "subnets" {
  value = module.vpc.subnets
}
output "backend_subnets" {
  value = [for each in module.vpc.subnets : each if each.tags["type"] == "backend"]
}
output "public_subnets" {
  value = [for each in module.vpc.subnets : each if each.tags["type"] == "web"]
}
output "rds_subnets" {
  value = [for each in module.vpc.subnets : each if each.tags["type"] == "rds"]
}
output "security_groups" {
  value = [aws_security_group.allow_http]
}