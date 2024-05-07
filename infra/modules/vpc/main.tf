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
  backend_subnets = toset([for each in aws_subnet.subnets : each if each.tags["type"] == "backend"])
  public_subnets  = [for each in aws_subnet.subnets : each if each.tags["type"] == "web"]
  rds_subnets     = toset([for each in aws_subnet.subnets : each if each.tags["type"] == "rds"])
}

# output "debug" {
#   value = local.route_tables_by_subnet_id["subnet-0c9f38a12c16153c9"]
# }

resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr_block
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = var.vpc_name
  }
}


resource "aws_subnet" "subnets" {
  count                   = length(var.cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_blocks[count.index].cidr_range
  availability_zone       = var.cidr_blocks[count.index].az
  map_public_ip_on_launch = var.cidr_blocks[count.index].exposed == true

  tags = {
    Name = "Subnet-${var.cidr_blocks[count.index].az}-${var.cidr_blocks[count.index].tag}"
    type = var.cidr_blocks[count.index].tag
  }
}


resource "aws_internet_gateway" "gw" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main internetgateway"
  }
}


resource "aws_route_table" "public_route_tables" {
  count  = length(local.public_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw[0].id
  }
  tags = {
    Name      = "${var.vpc_name}-${local.public_subnets[count.index].availability_zone}-rt"
    subnet_id = local.public_subnets[count.index].id
  }
}

# Associate public subnets with public a public route table
resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(aws_route_table.public_route_tables)
  subnet_id      = aws_route_table.public_route_tables[count.index].tags["subnet_id"]
  route_table_id = aws_route_table.public_route_tables[count.index].id
}
