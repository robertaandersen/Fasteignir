

resource "aws_db_subnet_group" "my_db_subnet_group" {

  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.db_subnet_ids
  tags = {
    Name = "My DB Subnet Group"
  }

}
resource "aws_db_instance" "db" {
  engine                 = "postgres"
  db_name                = "fasteignir"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  publicly_accessible    = true
  username               = var.username
  password               = var.password
  vpc_security_group_ids = var.security_group_ids
  storage_type           = "gp2"
  skip_final_snapshot    = true
  engine_version         = "16.1"
  availability_zone      = var.availability_zone
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name


  tags = {
    Name = var.db_name
  }
}

