# AWS DevOps Capstone Project

**Terraform-powered infrastructure with automated CI/CD and containerized deployment**

## Overview

This project demonstrates my ability to provision secure, scalable AWS infrastructure using Terraform, automate deployments with GitHub Actions, and containerize applications with Docker.

## Tech Stack

- **Infrastructure**: AWS (VPC, EC2, S3, Security Groups)
- **IaC**: Terraform
- **CI/CD**: GitHub Actions
- **App**: Static site on Nginx (Dockerized)
- **Language**: HCL (Terraform), Bash

## Architecture

- VPC with custom CIDR block
- 2 Subnets: one public, one private
- Internet Gateway + route tables
- EC2 instance with public IP
- Security Group with port 80/22 rules

## CI/CD Pipeline

1. Terraform fmt & validate
2. Docker image build & scan
3. Deploy app to EC2

## Dockerized App

Multi-stage Dockerfile for a static Nginx site, scanned with Trivy.

## Usage

```bash
git clone https://github.com/jasonvandeventer/terraform_capstone.git
cd terraform_capstone
terraform init
terraform plan
terraform apply
```

## Outputs

- EC2 Public IP
- VPC ID
- Subnet ID

## Author

Jason VanDeventer – [vanfreckle.com](https://vanfreckle.com)