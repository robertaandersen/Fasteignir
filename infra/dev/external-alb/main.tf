data aws_security_group allow_http {
  name = "Allow HTTP"
}

module "alb" {
  source             = "../../modules/alb"
  region             = var.region
  vpc_id             = var.vpc_id
  subnets            = var.subnets
  security_groups    = [data.aws_security_group.allow_http.id]
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
}


resource "aws_lb_target_group" "target_group" {
  name        = "${var.alb_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    port                = 80
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}


resource "aws_lb_target_group" "target_group_ip" {
  name        = "${var.alb_name}-ip-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    port                = 80
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}


# resource "aws_lb_target_group_attachment" "tg_attachments" {
#   target_group_arn = aws_lb_target_group.target_group.arn
#   target_id        = each.value
#   port             = 80
# }

# resource "aws_lb_listener" "lb_port_80_listener" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group.arn
#   }
# }