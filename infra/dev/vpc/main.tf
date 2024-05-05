locals {
  region = var.region
  web_subnets = [
    { cidr_range = "10.16.1.0/24", az = "eu-west-1a", tag = "web", exposed = true },
    { cidr_range = "10.16.2.0/24", az = "eu-west-1b", tag = "web", exposed = true },
    { cidr_range = "10.16.3.0/24", az = "eu-west-1c", tag = "web", exposed = true }
  ]
  backend_subnets = [
    { cidr_range = "10.16.4.0/24", az = "eu-west-1a", tag = "backend", exposed = false },
    { cidr_range = "10.16.5.0/24", az = "eu-west-1b", tag = "backend", exposed = false },
    { cidr_range = "10.16.6.0/24", az = "eu-west-1c", tag = "backend", exposed = false }
  ]
  rds_subnets = [
    { cidr_range = "10.16.7.0/24", az = "eu-west-1a", tag = "rds", exposed = false },
    { cidr_range = "10.16.8.0/24", az = "eu-west-1b", tag = "rds", exposed = false },
    { cidr_range = "10.16.9.0/24", az = "eu-west-1c", tag = "rds", exposed = false }
  ]
}

module "vpc" {
  source         = "../../modules/vpc"
  vpc_name       = "main_vpc"
  vpc_cidr_block = "10.16.0.0/18"
  region         = local.region
  subnets        = concat(local.web_subnets, local.backend_subnets, local.rds_subnets)
}