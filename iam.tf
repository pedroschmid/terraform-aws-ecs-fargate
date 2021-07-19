resource "aws_iam_role" "ecs_host_role" {
  name               = "ecs_host_role"
  assume_role_policy = file("policies/ecs-role.json")
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "ecs_instance_role_policy"
  policy = file("policies/ecs-instance-role-policy.json")
  role   = aws_iam_role.ecs_host_role.id
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs_service_role"
  assume_role_policy = file("policies/ecs-role.json")
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs_service_role_policy"
  policy = file("policies/ecs-service-role-policy.json")
  role   = aws_iam_role.ecs_service_role.id
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs_instance_profile"
  path = "/"
  role = aws_iam_role.ecs_host_role.name
}


resource "aws_iam_role" "ecs_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = file("policies/ecs-task-execution-role.json")
}

resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name   = "ecs_execution_role_policy"
  policy = file("policies/ecs-execution-role-policy.json")
  role   = aws_iam_role.ecs_execution_role.id
}