data "aws_security_group" "allow_db_sg" {
  name = "Allow DB"
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


