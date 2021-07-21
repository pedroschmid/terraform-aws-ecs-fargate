# CODEPIPELINE #

# Codepipeline itself #
resource "aws_codepipeline" "pipeline" {
  name     = "rails-pipeline-${var.ENVIRONMENT}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.source.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        Owner      = "pedroschmid"
        Repo       = "rails-example"
        Branch     = "master"
        OAuthToken = var.GITHUB_OAUTH_TOKEN

      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["build-output"]

      configuration = {
        ProjectName = "rails-codebuild-${var.ENVIRONMENT}"
      }
    }
  }

  stage {
    name = "Production"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build-output"]
      version         = "1"

      configuration = {
        ClusterName = aws_ecs_cluster.this.name
        ServiceName = aws_ecs_service.rails.name
        FileName    = "build-output.json"
      }
    }
  }
}