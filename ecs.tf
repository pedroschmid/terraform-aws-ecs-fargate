# ECS #

# ECS cluster #
resource "aws_ecs_cluster" "this" {
  name = "ecs-cluster-${var.ENVIRONMENT}"
}

# Template file for rails #
data "template_file" "rails" {
  template = file("templates/rails.json.tpl")

  vars = {
    ECR_REPOSITORY    = aws_ecr_repository.rails.repository_url
    DATABASE_HOST     = aws_db_instance.this.address
    DATABASE_NAME     = var.DATABASE_NAME
    DATABASE_USERNAME = var.DATABASE_USERNAME
    DATABASE_PASSWORD = var.DATABASE_PASSWORD
    AWS_REGION        = var.REGION
    ENVIRONMENT       = var.ENVIRONMENT
  }
}

# Template file for DB migration #
data "template_file" "migrations" {
  template = file("templates/migrations.json.tpl")

  vars = {
    ECR_REPOSITORY    = aws_ecr_repository.rails.repository_url
    DATABASE_HOST     = aws_db_instance.this.address
    DATABASE_NAME     = var.DATABASE_NAME
    DATABASE_USERNAME = var.DATABASE_USERNAME
    DATABASE_PASSWORD = var.DATABASE_PASSWORD
    ENVIRONMENT       = var.ENVIRONMENT
  }
}

# Rails task definition #
resource "aws_ecs_task_definition" "rails" {
  family                   = "rails-${var.ENVIRONMENT}"
  container_definitions    = data.template_file.rails.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_execution_role.arn

  depends_on = [aws_db_instance.this]
}

# DB migration task definition #
resource "aws_ecs_task_definition" "migrations" {
  family                   = "migrations-${var.ENVIRONMENT}"
  container_definitions    = data.template_file.migrations.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_execution_role.arn

  depends_on = [aws_db_instance.this]
}

# ECS service #
resource "aws_ecs_service" "rails" {
  name            = "rails-ecs-service-${var.ENVIRONMENT}"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.rails.arn
  desired_count   = 1

  depends_on = [
    aws_alb_listener.this,
    aws_iam_role_policy.ecs_service_role_policy
  ]

  load_balancer {
    target_group_arn = aws_alb_target_group.rails.arn
    container_name   = "rails"
    container_port   = 3000
  }

  network_configuration {
    security_groups = [aws_security_group.alb.id, aws_security_group.ecs.id, aws_security_group.rds.id]
    subnets         = aws_subnet.private.*.id
  }
}