variable "region" {
  description = "The AWS region"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnets" {
  description = "The list of public subnets"
  type        = list(string)
}

variable "alb_name" {
  description = "The name of the external ALB"
  type        = string
}
