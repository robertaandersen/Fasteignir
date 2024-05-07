data "aws_caller_identity" "current" {}
resource "aws_ecs_cluster" "backend_cluster" {
  name = var.cluster_name
}


resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name = aws_ecs_cluster.backend_cluster.name

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}



# resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_providers" {
#   cluster_name       = aws_ecs_cluster.backend_cluster.name
#   capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]
# }



resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = "${var.cluster_name}-tasks"
  network_mode       = var.task_settings.network_mode
  execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  cpu                = var.task_settings.cpu
  memory             = var.task_settings.memory

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name  = var.task_settings.container.name
      image = var.task_settings.container.image
      portMappings = [
        {
          name          = "${var.task_settings.container.name}-port-${var.task_settings.container.port}",
          containerPort = var.task_settings.container.port,
          hostPort      = var.task_settings.container.hostPort,
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
    }
  ])
}


# resource "aws_ecs_service" "mongo" {
#   name            = "mongodb"
#   cluster         = aws_ecs_cluster.foo.id
#   task_definition = aws_ecs_task_definition.mongo.arn
#   desired_count   = 3
#   iam_role        = aws_iam_role.foo.arn
#   depends_on      = [aws_iam_role_policy.foo]

#   ordered_placement_strategy {
#     type  = "binpack"
#     field = "cpu"
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.foo.arn
#     container_name   = "mongo"
#     container_port   = 8080
#   }

#   placement_constraints {
#     type       = "memberOf"
#     expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
#   }
# }