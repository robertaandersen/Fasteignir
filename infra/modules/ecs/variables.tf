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