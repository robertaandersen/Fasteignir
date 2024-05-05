terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  exposed_subnets = [for subnet in var.subnets : subnet if subnet.exposed == true]
  private_subnets = [for subnet in var.subnets : subnet if subnet.exposed == false]
}

resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr_block
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(local.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnets[count.index].cidr_range
  availability_zone = local.private_subnets[count.index].az

  tags = {
    Name = "Subnet-${local.private_subnets[count.index].az}-${local.private_subnets[count.index].tag}"
    type = local.private_subnets[count.index].tag
  }
}
resource "aws_subnet" "public_subnets" {
  count                   = length(local.exposed_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.exposed_subnets[count.index].cidr_range
  availability_zone       = local.exposed_subnets[count.index].az
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-${local.exposed_subnets[count.index].az}-${local.exposed_subnets[count.index].tag}"
  }
}


resource "aws_internet_gateway" "gw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main internetgateway"
  }
}


resource "aws_route_table" "route_table" {
  count  = length(aws_subnet.public_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw[0].id
  }
  tags = {
    Name = "${var.vpc_name}-${aws_subnet.public_subnets[count.index].availability_zone}-${aws_subnet.public_subnets[count.index].tags["Name"]}-rt"
    az   = local.exposed_subnets[count.index].az
  }
}

resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.route_table[count.index].id
}
