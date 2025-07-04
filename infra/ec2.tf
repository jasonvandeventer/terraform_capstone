resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_az1.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name                    = "HomelabEC2SSH"

  user_data = <<-EOF
              #!/bin/bash
              set -ex

              # Update and install Docker
              dnf update -y
              dnf install docker -y

              # Start and enable Docker
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user

              # Run your container (fallback to Nginx if custom fails)
              docker run -d -p 80:80 --name capstone-app coruscantsunrise/capstone-nginx:latest 

              EOF

  tags = {
    Name = "capstone-web"
  }
}
