variable "password" {
  type      = string
  sensitive = true
}
variable "username" {
  type      = string
  sensitive = true
}

variable "db_subnet_ids" {
  type = list(string)

}