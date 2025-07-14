resource "aws_instance" "web" {
  count         = var.low_cost ? 1 : 0
  ami           = var.ami_id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_az1.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true

  user_data = base64encode(<<EOF
#!/bin/bash
exec > /var/log/user_data_debug.log 2>&1
set -x

yum update -y
yum install -y docker
systemctl enable docker
systemctl start docker

sleep 15

docker pull coruscantsunrise/capstone-nginx:latest
docker run -d -p 80:80 coruscantsunrise/capstone-nginx:latest
EOF
  )

  tags = {
    Name = "capstone-web-standalone"
  }
}
