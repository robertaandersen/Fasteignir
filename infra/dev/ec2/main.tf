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


module "ec2" {
  count             = length(var.subnets)
  source            = "../../modules/ec2"
  vpc_id            = var.vpc_id
  region            = var.region
  subnet_id         = var.subnets[count.index].id
  security_group_id = var.security_group_id
  ami               = data.aws_ami.ami.id
  name              = "${var.subnets[count.index].id}-ec2-instance"
  jumpbox_key       = var.jumpbox_key
  user_data         = <<EOF
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