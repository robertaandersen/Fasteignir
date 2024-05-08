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
variable "alb_name" {
  type        = string
  description = "Name of alb"
}


variable "task_settings" {
  type = object({
    cpu              = number
    network_mode     = string
    memory           = number
    desired_count    = number
    assign_public_ip = bool
    container = object({
      name     = string
      image    = string
      port     = number
      hostPort = number
      db_password_arn = string
      db_user_arn = string
      db_host_arn = string
    })
  })
  description = "The settings for the ECS task"
}