terraform {
  backend "s3" {
    bucket  = "6bc7db9b3321-tfstate"
    key     = "vpc/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}
locals {
  region          = "eu-west-1"
  jumpbox_key     = "jumpbox-key"
  backend_subnets = compact(toset([for each in module.vpc.private_subnets : each.tags["type"] == "backend" ? each.id : null]))
}
module "vpc" {
  source = "./vpc"
  region = local.region
}

module "ec2" {
  source           = "./ec2"
  region           = local.region
  vpc_id           = module.vpc.vpc_id
  jumpbox_key      = local.jumpbox_key
  subnets          = module.vpc.public_subnets
  target_group_arn = module.external-alb.target_group_arn
}

module "external-alb" {
  source            = "./external-alb"
  alb_name          = "external-alb"
  region            = local.region
  vpc_id            = module.vpc.vpc_id
  subnets           = module.vpc.public_subnets.*.id
  security_group_id = module.ec2.http_security_group_id
}

# module "ecs_backend_cluster" {
#   source             = "./ecs"
#   subnets            = local.backend_subnets
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
