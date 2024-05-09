data "aws_caller_identity" "current" {}
resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}
resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

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
        }]
        environment: [{"name": "TEST_ENV", "value": "Environment"}],
        secrets: [
          {"name": "POSTGRES_PASSWORD","valueFrom": var.task_settings.container.db_password_arn},
          {"name": "POSTGRES_USER","valueFrom": var.task_settings.container.db_user_arn},
          {"name": "POSTGRES_HOST","valueFrom": var.task_settings.container.db_host_arn},
        ]}
  ])
}

resource "aws_ecs_service" "service" {
  name            = "${var.cluster_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.task_settings.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.task_settings.assign_public_ip
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.task_settings.container.name
    container_port   = var.load_balancer_container_port
  }
}
