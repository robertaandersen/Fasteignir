variable "region" {
  description = "The AWS region where the EC2 instance will be launched"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be launched"
  type        = string
}

variable "name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_id" {
  type = string

}
variable "security_group_id" {
  type = string

}

variable "ami" {
  description = "The ID of the AMI to use for the EC2 instance."
  type        = string
}

variable "jumpbox_key" {
  description = "The name of the key pair to use for the jumpbox."
  type        = string
  default     = ""
}

variable "user_data" {
  description = "The user data to provide to the EC2 instance."
  type        = string
  default     = ""

}