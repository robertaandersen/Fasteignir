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
  cidr_blocks    = concat(local.web_subnets, local.backend_subnets, local.rds_subnets)
}


resource "aws_security_group" "allow_http" {
  name        = "Allow HTTP"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from Anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "HTTP"
  }
}

resource "aws_security_group" "allow_ssh_sg" {
  name        = "Allow ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "SSH from Home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["89.17.152.11/32"]
  }
  ingress {
    description = "SSH from Work"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["213.181.116.102/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# output debug {
#   value = module.vpc.debug
# }