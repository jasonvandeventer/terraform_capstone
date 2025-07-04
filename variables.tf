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

variable "public_subnet_cidr_az1" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone_1" {
  description = "AZ for the subnet"
  type        = string
  default     = "us-east-2a"
}

variable "public_subnet_cidr_az2" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone_2" {
  description = "AZ for the second public subnet"
  type        = string
  default     = "us-east-2b"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0c803b171269e2d72"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "HomelabEC2SSH"
}