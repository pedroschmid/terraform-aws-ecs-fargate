# SG #

# ALB (Traffic Internet --> ALB)
resource "aws_security_group" "alb" {
  name        = "alb-sg-${var.ENVIRONMENT}"
  description = "Controls access to the ALB"
  vpc_id      = aws_vpc.this.id

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS (traffic ALB --> ECS || SSH --> ECS)
resource "aws_security_group" "ecs" {
  name        = "ecs-sg-${var.ENVIRONMENT}"
  description = "Allow inboud access from the ALB only"
  vpc_id      = aws_vpc.this.id

  # ALB
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb.id]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS (traffic ECS --> RDS)
resource "aws_security_group" "rds" {
  name        = "rds-sg-${var.ENVIRONMENT}"
  description = "Allows inboud access from ECS to RDS"
  vpc_id      = aws_vpc.this.id

  ingress {
    protocol        = "tcp"
    from_port       = "5432"
    to_port         = "5432"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}