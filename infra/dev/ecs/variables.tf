variable "subnets" {
  description = "The list of subnets to deploy the infrastructure"
  type        = set(string)
}

variable "security_group_ids" {
  description = "The list of security groups to attach to the ECS instances"
  type        = set(string)

}