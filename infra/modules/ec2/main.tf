locals {
  # ec2_ssh_enabled = [for instance in aws_instance.ec2_instance: instance if instance.tags.ssh == "true" ]
  apache_userdata = <<EOF
    #! /bin/bash
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo usermod -a -G apache ec2-user
    sudo chown -R ec2-user:apache /var/www
    sudo chmod 2775 /var/www
    find /var/www -type d -exec sudo chmod 2775 {} \;
    find /var/www -type f -exec sudo chmod 0664 {} \;
    export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
    sudo echo "<h1>Hallo from autoscaled-instance $INSTANCE_ID</h1>" >/var/www/html/index.html
  EOF
}

locals {
  target_group_name = "${var.alb_name}-tg" #BUG terraform complains that target group can't start with '-'
}

output "debug" {
  value = "data.aws_security_group.allow_ssh_sg"
}

data "aws_lb" "external_alb" {
  name = var.alb_name
}
data "aws_lb_target_group" "target_group" {
  name = "external-alb-tg"
}
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

resource "aws_instance" "ec2_instance" {
  count                       = var.ec2_instances != null ? length(var.ec2_instances) : 0
  ami                         = data.aws_ami.ami.id
  instance_type               = var.instance_type
  subnet_id                   = var.ec2_instances[count.index].subnet_id
  vpc_security_group_ids      = var.ec2_instances[count.index].security_group_ids
  associate_public_ip_address = var.ec2_instances[count.index].public_ip
  key_name                    = var.ec2_instances[count.index].key_name
  user_data                   = local.apache_userdata
  tags = {
    Name = var.name
  }
}


resource "aws_launch_template" "ec2" {
  name_prefix                          = "ec2-auto-scaling"
  image_id                             = data.aws_ami.ami.id
  instance_type                        = "t2.micro"
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = var.launch_template.security_group_ids
  user_data                            = base64encode(local.apache_userdata)


  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg" {
  name                = "${var.launch_template.name}-asg"
  min_size            = var.launch_template.min_size
  max_size            = var.launch_template.max_size
  desired_capacity    = var.launch_template.desired_capacity
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [data.aws_lb_target_group.target_group.arn]
  launch_template {
    id      = aws_launch_template.ec2.id
    version = "$Latest"

  }
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }
}

resource "aws_lb_listener" "lb_port_80_listener" {
  load_balancer_arn = data.aws_lb.external_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = data.aws_lb_target_group.target_group.arn
  }
}

# resource "aws_lb_target_group_attachment" "tg_attachments" {
#   for_each         = var.ec2_instance_ids != null ? toset(var.ec2_instance_ids) : []
#   target_group_arn = aws_lb_target_group.target_group.arn
#   target_id        = each.value
#   port             = 80
# }


