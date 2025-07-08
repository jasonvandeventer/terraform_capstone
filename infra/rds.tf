resource "random_password" "rds" {
  length  = 16
  special = true
}

# RDS Subnet Group (uses private subnets)
resource "aws_db_subnet_group" "main" {
  name = "capstone-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_az1.id,
    aws_subnet.private_az2.id
  ]
  tags = {
    Name = "capstone-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier              = "capstone-db"
  allocated_storage       = 20
  storage_type            = "gp3"
  engine                  = "postgres"
  engine_version          = "17.5"
  instance_class          = "db.t3.micro"
  username                = "capstone_admin"
  password                = random_password.rds.result
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 7
  multi_az                = true
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.main.name

  tags = {
    Name        = "capstone-db"
    Environment = "dev"
  }
}


