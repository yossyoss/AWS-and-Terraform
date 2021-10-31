resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nginx_instances_access.id]
  subnets            = var.public_subnets_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.purpose_tag}-web-alb"
  }
}

resource "aws_alb_target_group" "nginx_web_servers" {
  name     = "alb-web-servers-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 60
    enabled         = true
  }

  health_check {
    port                = 80
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 10
  }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.nginx_web_servers.arn
  }
}

resource "aws_alb_target_group_attachment" "web_alb_to_nginx_web_servers" {
  count            = var.instance_count
  target_group_arn = aws_alb_target_group.nginx_web_servers.arn
  target_id        = aws_instance.nginx_web_servers.*.id[count.index]
  port             = 80
}