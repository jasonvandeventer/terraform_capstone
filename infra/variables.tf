variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0c803b171269e2d72"
}

variable "availability_zone_1" {
  description = "AZ for the main subnets"
  type        = string
  default     = "us-east-2a"
}

variable "availability_zone_2" {
  description = "AZ for the second subnets"
  type        = string
  default     = "us-east-2b"
}

variable "domain_name" {
  description = "Primary domain name for the certificate"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "HomelabEC2SSH"
}

variable "private_subnet_cidr_az1" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_az2" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "public_subnet_cidr_az1" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_az2" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_engine_version" {
  default = "17.5"
}

variable "db_instance_class" {
  default = "db.t3.micro"
}

locals {
  deploy_version = timestamp()
}

variable "low_cost" {
  description = "Enable low-cost mode to minimize AWS charges"
  type        = bool
  default     = true
}

variable "alert_email" {
  description = "Email address to receive SNS alerts"
  type        = string
  default     = "" # Optional: could be null if you want stricter enforcement
}