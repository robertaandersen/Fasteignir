data "aws_security_group" "allow_db_sg" {
  name = "Allow DB"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/production/database/password/master"
  description = "The parameter description"
  type        = "SecureString"
  value       = "Hallo"
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


