# CODEBUILD #

# Template file for pipeline #
data "template_file" "buildspec" {
  template = file("buildspec/rails.yml")

  vars = {
    IMAGE        = aws_ecr_repository.rails.repository_url
    CLUSTER_NAME = aws_ecs_cluster.this.name
    REGION       = var.REGION
    ENVIRONMENT  = var.ENVIRONMENT
  }
}


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