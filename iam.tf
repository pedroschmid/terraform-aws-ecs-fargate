# IAM #

# ECS #
resource "aws_iam_role" "ecs_host_role" {
  name               = "ecs-host-role"
  assume_role_policy = file("policies/ecs/ecs-role.json")
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "ecs-instance-role-policy"
  policy = file("policies/ecs/ecs-instance-role-policy.json")
  role   = aws_iam_role.ecs_host_role.id
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs-service-role"
  assume_role_policy = file("policies/ecs/ecs-role.json")
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs-service-role-policy"
  policy = file("policies/ecs/ecs-service-role-policy.json")
  role   = aws_iam_role.ecs_service_role.id
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs_host_role.name
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "ecs-task-execution-role"
  assume_role_policy = file("policies/ecs/ecs-task-execution-role.json")
}

resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name   = "ecs-execution-role-policy"
  policy = file("policies/ecs/ecs-execution-role-policy.json")
  role   = aws_iam_role.ecs_execution_role.id
}

# CODEBUILD # 
resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild-role"
  assume_role_policy = file("policies/codebuild/codebuild_role.json")
}

data "template_file" "codebuild_policy" {
  template = file("policies/codebuild/codebuild_policy.json")
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "codebuild-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.template_file.codebuild_policy.rendered
}