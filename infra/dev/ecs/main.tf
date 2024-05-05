module "cluster" {
  source             = "../../modules/ecs"
  cluster_name       = "backend-cluster"
  subnet_ids         = var.subnets
  security_group_ids = var.security_group_ids
}

