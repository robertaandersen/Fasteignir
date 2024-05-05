variable "region" {
  description = "The AWS region where the resources will be provisioned."
  type        = string
}
# variable "instance_name" {
#   description = "Ec2 instance name."
#   type        = string
# }

variable "vpc_id" {
  description = "The ID of the VPC where the resources will be provisioned."
  type        = string
}

variable "subnets" {
  description = "The IDs of the Subnets where the resources will be provisioned."
  type        = list(any)
}

variable "security_group_id" {
  description = "The security group to attach to the resources."
  type        = string
}

variable "jumpbox_key" {
  description = "The name of the key pair to use for the jumpbox."
  type        = string
  default     = ""
}