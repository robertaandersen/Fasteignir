resource "aws_ecs_cluster" "backend_cluster" {
  name = var.cluster_name
}


resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_providers" {
  cluster_name       = aws_ecs_cluster.backend_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]
}

