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

variable "security_group_id" {
  description = "The ID of the security group allowing SSH"
  type        = string
}
variable "alb_name" {
  description = "The name of the external ALB"
  type        = string
}

variable "ec2_instance_ids" {
  description = "The list of EC2 instance IDs"
  type        = list(string)

}