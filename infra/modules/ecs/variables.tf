variable "cluster_name" {
  type        = string
  description = "The name of the resource"
}

variable "subnet_ids" {
  type        = set(string)
  description = "The list of subnets to deploy the infrastructure"
}

variable "security_group_ids" {
  type        = set(string)
  description = "The list of security groups to attach to the ECS instances"
}


variable "task_settings" {
  type = object({
    cpu          = number
    network_mode = string
    memory       = number
    container = object({
      name     = string
      image    = string
      port     = number
      hostPort = number
    })
  })
  description = "The settings for the ECS task"
  default = {
    network_mode = "awsvpc"
    cpu          = 1024
    memory       = 3072
    container = {
      name     = "nginx"
      image    = "nginx"
      port     = 80
      hostPort = 80
    }
  }

}

