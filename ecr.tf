resource "aws_ecr_repository" "rails" {
  name = "repository/rails-${var.ENVIRONMENT}"
}