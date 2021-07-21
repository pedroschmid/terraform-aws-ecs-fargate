locals {
  BUCKET_NAME = "rails-bucket-62c75794a9067261ad1941519a3cfd3d-${var.ENVIRONMENT}"
}

# S3 #

# Bucket for codebuild and codepipeline source
resource "aws_s3_bucket" "source" {
  bucket        = local.BUCKET_NAME
  acl           = "private"
  force_destroy = true
}