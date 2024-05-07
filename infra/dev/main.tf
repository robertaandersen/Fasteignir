terraform {
  backend "s3" {
    bucket  = "6bc7db9b3321-tfstate"
    key     = "vpc/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}
locals {
  region      = "eu-west-1"
  jumpbox_key = "jumpbox-key"
  alb_name          = "external-alb"
}
module "networking" {
  source = "./networking"
  region = local.region
}


module "ec2" {
  source             = "./ec2"
  region             = local.region
  vpc_id             = module.networking.vpc_id
  jumpbox_key        = local.jumpbox_key
  alb_name = local.alb_name
  subnet_ids         = [module.networking.public_subnets[0].id]
}

output "debug" {
  value = module.ec2.debug
}

module "external-alb" {
  source            = "./external-alb"
  alb_name          = local.alb_name
  region            = local.region
  vpc_id            = module.networking.vpc_id
  subnets           = module.networking.public_subnets.*.id
}

# module "ecs_backend_cluster" {
#   source             = "./ecs"
#   subnets            = local.public_subnets
#   security_group_ids = [module.ec2.http_security_group_id]
# }

# module "ecs-alb" {
#   source            = "./ecs-alb"
#   alb_name          = "ecs-alb"
#   region            = local.region
#   vpc_id            = module.vpc.vpc_id
#   subnets           = local.backend_subnets
#   security_group_id = module.ec2.http_security_group_id
# }
