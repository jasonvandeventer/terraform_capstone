resource "aws_launch_template" "web" {
  name_prefix   = "capstone-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_s3_profile.name
  }
  depends_on = [aws_iam_instance_profile.ec2_s3_profile]

  key_name = var.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

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
      Name        = "capstone-app-instance"
      DeployCycle = local.deploy_version
    }
  }

  user_data = base64encode(<<EOF
#!/bin/bash
exec > /var/log/user_data_debug.log 2>&1
set -x

yum update -y
yum install -y docker
systemctl enable docker
systemctl start docker

sleep 15

sudo docker pull coruscantsunrise/capstone-nginx:latest
sudo docker run -d -p 80:80 coruscantsunrise/capstone-nginx:latest
EOF
  )
}

resource "aws_autoscaling_group" "web_asg" {
  name             = "capstone-asg"
  max_size         = 2
  min_size         = 1
  desired_capacity = 1

  vpc_zone_identifier = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  target_group_arns = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  depends_on = [aws_lb_listener.http]

  tag {
    key                 = "Name"
    value               = "capstone-app-asg-instance"
    propagate_at_launch = true
  }
}