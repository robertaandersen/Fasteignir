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
}
module "vpc" {
  source = "./vpc"
  region = local.region
}

module "ec2" {
  source            = "./ec2"
  region            = local.region
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.vpc.allow_ssh_sg_security_group_id
  jumpbox_key       = local.jumpbox_key
  subnets           = module.vpc.public_subnets
}