module "alb" {
  source             = "../../modules/alb"
  region             = var.region
  vpc_id             = var.vpc_id
  subnets            = var.subnets
  security_groups    = [var.security_group_id]
  ec2_instance_ids   = var.ec2_instance_ids
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
}