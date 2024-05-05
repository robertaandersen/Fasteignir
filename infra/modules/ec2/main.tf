resource "aws_instance" "ec2_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  key_name                    = var.jumpbox_key != "" ? var.jumpbox_key : null
  user_data                   = var.user_data

  tags = {
    Name = var.name
  }
}
