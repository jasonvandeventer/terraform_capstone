resource "random_password" "rds" {
  count   = var.low_cost ? 0 : 1
  length  = 16
  special = true
}

# DB Parameter Group
resource "aws_db_parameter_group" "pg" {
  count       = var.low_cost ? 0 : 1
  name        = "capstone-db-pg"
  family      = "postgres17"
  description = "Parameter group for PostgreSQL 17.5"

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  tags = {
    Name = "capstone-db-pg"
  }
}

# DB Subnet Group (used only by RDS)
resource "aws_db_subnet_group" "main" {
  count = var.low_cost ? 0 : 1
  name  = "capstone-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_az1.id,
    aws_subnet.private_az2.id
  ]
  tags = {
    Name = "capstone-db-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "main" {
  count                   = var.low_cost ? 0 : 1
  identifier              = "capstone-db"
  allocated_storage       = 20
  storage_type            = "gp3"
  engine                  = "postgres"
  engine_version          = "17.5"
  instance_class          = "db.t3.micro"
  username                = "capstone_admin"
  password                = random_password.rds[0].result
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 7
  multi_az                = true
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.main[0].name
  parameter_group_name    = aws_db_parameter_group.pg[0].name
  apply_immediately       = true

  tags = {
    Name        = "capstone-db"
    Environment = "dev"
  }
}
