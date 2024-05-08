

data "aws_caller_identity" "current" {}
locals {
  create_ec2 = false
  ecs2_in_each_subnet = [for subnet in var.subnet_ids : {
    subnet_id          = subnet,
    name               = "Autoscaled EC2 instance in subnet ${subnet}",
    key_name           = var.jumpbox_key,
    public_ip          = true,
    security_group_ids = [data.aws_security_group.allow_http.id]
    }
  ]
}

data "aws_security_group" "allow_ssh_sg" {
  name = "Allow ssh"
}

data "aws_security_group" "allow_http" {
  name = "Allow HTTP"
}


# module "ec2" {
#   source     = "../../modules/ec2"
#   region     = var.region
#   name       = "DEV EC2 Jumpboxes and demo instances"
#   subnet_ids = var.subnet_ids
#   vpc_id     = var.vpc_id
#   # ec2_instances      = local.create_ec2 ? local.ecs2_in_each_subnet : null
#   launch_template = {
#     name               = "ec2-launch-template"
#     subnet_ids         = var.subnet_ids
#     public_ip          = false
#     key_name           = var.jumpbox_key
#     min_size           = 1
#     max_size           = 1
#     desired_capacity   = 1
#     security_group_ids = [data.aws_security_group.allow_http.id]
#   }
# }

data "aws_ssm_parameter" "db_password" {
  name = "/production/database/password/master"

}




resource "aws_iam_policy" "database_secrets" {
  name        = "read-db-secrets"
  path        = "/"
  description = "IAM policy for fetching secrets for databases"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:DescribeParameters",
        "ssm:GetParametersByPath"
      ],
      "Resource": "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/production/database/*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

data "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
}
resource "aws_iam_role_policy_attachment" "db_write_get_db_secrets" {
  role       = data.aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = aws_iam_policy.database_secrets.arn
}



module "frontend-cluster" {
  source             = "../../modules/ecs"
  cluster_name       = "frontend-cluster"
  subnet_ids         = var.subnet_ids
  security_group_ids = [data.aws_security_group.allow_http.id]
  alb_name           = var.alb_name
  task_settings = {
    network_mode     = "awsvpc"
    cpu              = 1024
    memory           = 3072
    desired_count    = 1
    assign_public_ip = true
    container = {
      name  = "fasteignir"
      image = "992382615085.dkr.ecr.eu-west-1.amazonaws.com/fasteignir-backend:latest"
      # image    = "nginx:latest"
      port     = 8080
      hostPort = 8080
      db_password_secret_arn = data.aws_ssm_parameter.db_password.arn
    }
  }
}




# resource "tls_private_key" "ec2_key_pair" {
#   count     = local.create_ec2 ? 1 : 0
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "local_file" "tf_key" {
#   count    = local.create_ec2 ? 1 : 0
#   content  = tls_private_key.ec2_key_pair[0].private_key_pem
#   filename = "${var.jumpbox_key}.pem"
# }

# resource "aws_key_pair" "generated_key" {
#   count      = local.create_ec2 ? 1 : 0
#   key_name   = var.jumpbox_key
#   public_key = tls_private_key.ec2_key_pair[0].public_key_openssh
# }

# output "debug" {
#   value = "module.ec2.debug"
# }

