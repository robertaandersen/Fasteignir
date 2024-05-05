variable "name" {
  description = "The name of the ALB"
  type        = string
}

variable "internal" {
  description = "Whether the ALB is internal or external"
  type        = bool
}

variable "load_balancer_type" {
  description = "The type of load balancer"
  type        = string
}

variable "security_groups" {
  description = "The security groups associated with the ALB"
  type        = list(string)
}

variable "subnets" {
  description = "The subnets where the ALB will be deployed"
  type        = list(string)
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "ec2_instance_ids" {
  description = "The list of EC2 instance IDs"
  type        = list(string)
  default     = null
}

variable "target_type" {
  description = "The type of target"
  type        = string
  default     = "instance"

}