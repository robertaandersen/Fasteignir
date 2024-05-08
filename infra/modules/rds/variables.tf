variable "db_name" {
  type      = string
  sensitive = true
}
variable "password" {
  type      = string
  sensitive = true
}

variable "username" {
  type      = string
  sensitive = true
}

variable "security_group_ids" {
  type = list(string)
}

variable "availability_zone" {
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}
