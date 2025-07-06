resource "aws_launch_template" "web" {
  name_prefix   = "capstone-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups             = [aws_security_group.web_sg.id]
    associate_public_ip_address = true
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "capstone-app-instance"
    }
  }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF
  )
}

resource "aws_autoscaling_group" "web_asg" {
  name             = "capstone-asg"
  max_size         = 2
  min_size         = 1
  desired_capacity = 2
  vpc_zone_identifier = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id
  ]
  health_check_type = "EC2"
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web.arn]
  depends_on        = [aws_lb_listener.http]

  tag {
    key                 = "Name"
    value               = "capstone-app-asg-instance"
    propagate_at_launch = true
  }
}