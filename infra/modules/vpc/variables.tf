variable "region" {
  description = "The AWS region to deploy the VPC."
  type        = string
}
variable "vpc_name" {
  description = "VPC name."
  type        = string
}
variable "create_igw" {
  description = "Should an internet gateway be created?"
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.16.0.0/16"
}

variable "subnets" {
  description = "List of CIDR blocks for each subnet."
  type = list(object({
    cidr_range = string
    az         = string
    tag        = string
    exposed    = bool
  }))
}