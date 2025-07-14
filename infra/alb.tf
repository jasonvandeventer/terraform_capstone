# Application Load Balancer
resource "aws_lb" "main" {
  count              = var.low_cost ? 0 : 1
  name               = "capstone-alb"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id
  ]
  security_groups = [aws_security_group.alb_sg.id]

  enable_deletion_protection = false

  tags = {
    Name = "capstone-alb"
  }
}

# Target Group for EC2 instances
resource "aws_lb_target_group" "web" {
  count    = var.low_cost ? 0 : 1
  name     = "capstone-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "capstone-tg"
  }
}

# HTTP Listener (for redirect to HTTPS)
resource "aws_lb_listener" "http" {
  count             = var.low_cost ? 0 : 1
  load_balancer_arn = var.low_cost ? null : aws_lb.main[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  count             = var.low_cost ? 0 : 1
  load_balancer_arn = var.low_cost ? null : aws_lb.main[0].arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.low_cost ? null : aws_acm_certificate.main[0].arn

  default_action {
    type             = "forward"
    target_group_arn = var.low_cost ? null : aws_lb_target_group.web[0].arn
  }
}
