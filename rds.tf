# RDS #

# RDS subnet group
resource "aws_db_subnet_group" "this" {
  name       = "main"
  subnet_ids = aws_subnet.private.*.id
}

# RDS instance
resource "aws_db_instance" "this" {
  identifier = "rds-${var.ENVIRONMENT}"

  # General
  engine                  = "postgres"
  engine_version          = "9.6"
  instance_class          = "db.t2.micro"
  allocated_storage       = "20"
  storage_encrypted       = false
  storage_type            = "gp2"
  backup_retention_period = 7
  skip_final_snapshot     = true

  # Credentials
  name     = var.DATABASE_NAME
  username = var.DATABASE_USERNAME
  password = var.DATABASE_PASSWORD
  port     = "5432"

  # Network
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  multi_az               = false
  publicly_accessible    = false
}