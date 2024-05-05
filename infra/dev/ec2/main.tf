data "aws_ami" "ami" {
  most_recent = true
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami*"]
  }
  owners = ["amazon"]
}

resource "tls_private_key" "ec2_key_pair" {
  count     = var.jumpbox_key != "" ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf_key" {
  count    = var.jumpbox_key != "" ? 1 : 0
  content  = tls_private_key.ec2_key_pair[0].private_key_pem
  filename = "${var.jumpbox_key}.pem"

}

resource "aws_key_pair" "generated_key" {
  count      = var.jumpbox_key != "" ? 1 : 0
  key_name   = var.jumpbox_key
  public_key = tls_private_key.ec2_key_pair[0].public_key_openssh
}

resource "aws_security_group" "allow_http" {
  name        = "Allow HTTP"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from Anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "allow_ssh_sg" {
  name        = "Allow ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    description = "SSH from Home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["89.17.152.11/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "ec2" {
  count              = length(var.subnets)
  source             = "../../modules/ec2"
  vpc_id             = var.vpc_id
  region             = var.region
  subnet_id          = var.subnets[count.index].id
  security_group_ids = [resource.aws_security_group.allow_ssh_sg.id, resource.aws_security_group.allow_http.id]
  ami                = data.aws_ami.ami.id
  name               = "${var.subnets[count.index].id}-ec2-instance"
  jumpbox_key        = var.jumpbox_key
  user_data          = <<EOF
    #! /bin/bash
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo usermod -a -G apache ec2-user
    sudo chown -R ec2-user:apache /var/www
    sudo chmod 2775 /var/www
    find /var/www -type d -exec sudo chmod 2775 {} \;
    find /var/www -type f -exec sudo chmod 0664 {} \;
    sudo echo "<h1>Hallo from ${var.subnets[count.index].id}-ec2-instance}</h1>" >/var/www/html/index.html
  EOF

}