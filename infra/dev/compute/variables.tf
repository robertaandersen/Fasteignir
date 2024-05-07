variable "region" {
  description = "The AWS region where the resources will be provisioned."
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC where the resources will be provisioned."
  type        = string
}
variable "target_group_arn" {
  description = "The arn of the target group for the resources."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "The IDs of the Subnets where the resources will be provisioned."
  type        = list(string)
}

variable "jumpbox_key" {
  description = "The name of the key pair to use for the jumpbox."
  type        = string
  default     = ""
}

variable "alb_name" {
  description = "The name of the Application Load Balancer."
  type        = string
  default     = ""

}
