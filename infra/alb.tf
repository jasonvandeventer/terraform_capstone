# Application Load Balancer
resource "aws_lb" "main" {
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

# HTTP Listener (for redirect or fallback)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
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

# HTTPS Listener (TLS termination using ACM cert)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
