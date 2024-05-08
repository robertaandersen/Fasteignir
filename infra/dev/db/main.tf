data "aws_security_group" "allow_db_sg" {
  name = "Allow DB"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/production/database/password"
  description = "password"
  type        = "SecureString"
  value       = var.password
}
resource "aws_ssm_parameter" "db_username" {
  name        = "/production/database/user"
  description = "The dbuser name"
  type        = "SecureString"
  value       = var.username
}
resource "aws_ssm_parameter" "db_host" {
  name        = "/production/database/host"
  description = "The db endpoint"
  value       = "Hallo"
  type = "String"
}


module "rds" {
  source             = "../../modules/rds"
  db_name            = "fasteignir"
  username           = var.username
  password           = var.password
  security_group_ids = [data.aws_security_group.allow_db_sg.id]
  availability_zone  = "eu-west-1a"
  db_subnet_ids      = var.db_subnet_ids
}


