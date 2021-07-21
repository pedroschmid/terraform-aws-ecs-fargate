# CODEBUILD #

# Template file for pipeline #
data "template_file" "buildspec" {
  template = file("buildspec/rails.yml")

  vars = {
    ECR_REPOSITORY   = aws_ecr_repository.rails.repository_url
    ECS_CLUSTER_NAME = aws_ecs_cluster.this.name
    ECS_SERVICE_NAME = aws_ecs_service.rails.name
    PRIVATE_SUBNET_ID = element(aws_subnet.private.*.id, 0)
    SECURITY_GROUP_IDS = join(",", [aws_security_group.alb.id, aws_security_group.ecs.id, aws_security_group.rds.id])
    AWS_REGION       = var.REGION
    ENVIRONMENT      = var.ENVIRONMENT
  }
}

# Codebuild itself #
resource "aws_codebuild_project" "rails" {
  name          = "rails-codebuild-${var.ENVIRONMENT}"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/docker:1.12.1"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec.rendered
  }
}