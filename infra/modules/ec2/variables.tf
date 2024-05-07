# Metadata
variable "region" {
  description = "The AWS region where the EC2 instance will be launched"
  type        = string
}
variable "name" {
  type = string
}

#### Network variables
variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "The ID of the subnet where the EC2 instance will be launched"
  type        = list(string)
}

variable "alb_name" {
  description = "The name of the Application Load Balancer."
  type        = string
  default     = ""

}

### Config
variable "ec2_instances" {
  type = list(object({
    name               = string
    subnet_id          = string
    public_ip          = bool
    key_name           = string
    security_group_ids = list(string)
  }))
  default = null
}

variable "launch_template" {
  type = object({
    name = string
    # subnet_ids   = list(string)
    # public_ip = bool
    # key_name = string
    security_group_ids = list(string)
    min_size           = number
    max_size           = number
    desired_capacity   = number
  })
  default = null
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

# variable "autoscaling_group" {
#   description = "The Autoscaling group."
#   type = object({
#     name                = string
#     min_size            = number
#     max_size            = number
#     desired_capacity    = number
#     vpc_zone_identifier = list(string)
#   })
#   default = null
# }
