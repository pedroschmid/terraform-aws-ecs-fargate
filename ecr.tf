# ECR #

# ECR repository #
resource "aws_ecr_repository" "rails" {
  name                 = "repository/rails-${var.ENVIRONMENT}"
  image_tag_mutability = "MUTABLE"
}