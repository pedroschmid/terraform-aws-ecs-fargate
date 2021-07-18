# LOGS #

# Cloudwatch log group
resource "aws_cloudwatch_log_group" "rails" {
  name              = "rails-log-group-${var.ENVIRONMENT}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "rails" {
  name           = "rails-log-stream-${var.ENVIRONMENT}"
  log_group_name = aws_cloudwatch_log_group.rails.name
}