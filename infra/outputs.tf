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
  value       = var.low_cost ? null : aws_lb.main[0].dns_name
  description = "DNS name of the ALB"
}

output "cert_validation_details" {
  value       = var.low_cost ? [] : aws_acm_certificate.main[0].domain_validation_options
  description = "ACM DNS records to validate domain"
}


output "rds_endpoint" {
  value       = var.low_cost ? null : aws_db_instance.main[0].endpoint
  description = "RDS Endpoint"
}

output "rds_db_name" {
  value       = var.low_cost ? null : aws_db_instance.main[0].db_name
  description = "The name of the RDS database"
}

output "dynamodb_table_name" {
  value       = try(aws_dynamodb_table.users.name, null)
  description = "Name of the DynamoDB table"
}

output "cloudtrail_kms_key_arn" {
  description = "ARN of the KMS key used for CloudTrail encryption"
  value       = aws_kms_key.cloudtrail.arn
}

output "cloudtrail_kms_key_id" {
  description = "Key ID of the KMS key used for CloudTrail encryption"
  value       = aws_kms_key.cloudtrail.key_id
}

output "low_cost_mode" {
  value       = var.low_cost
  description = "Indicates whether low-cost mode is active"
}

output "web_instance_public_ip" {
  value       = var.low_cost ? aws_instance.web[0].public_ip : null
  description = "Public IP of standalone EC2 instance (low-cost mode)"
}