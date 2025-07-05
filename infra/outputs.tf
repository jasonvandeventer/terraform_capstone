# VPC and Subnet Outputs
output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_az1_id" {
  description = "The ID of the public subnet in AZ1"
  value       = aws_subnet.public_az1.id
}

output "public_subnet_az2_id" {
  description = "The ID of the public subnet in AZ2"
  value       = aws_subnet.public_az2.id
}

# Security Group Outputs
output "security_group_id" {
  description = "The ID of the web security group"
  value       = aws_security_group.web_sg.id
}

# ALB and Certificate Outputs
output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "cert_validation_details" {
  description = "ACM certificate validation DNS details"
  value       = aws_acm_certificate.main.domain_validation_options
}
