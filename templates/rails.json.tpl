[
  {
    "name": "rails",
    "image": "${IMAGE}",
    "essential": true,
    "cpu": 10,
    "memory": 512,
    "links": [],
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "RAILS_ENV",
        "value": "${ENVIRONMENT}"
      },
      {
        "name": "DATABASE_URL",
        "value": "${DATABASE_URL}"
      },
      {
        "name": "PORT",
        "value": "3000"
      },
      {
        "name": "RAILS_LOG_TO_STDOUT",
        "value": "true"
      },
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${REGION}",
        "awslogs-group": "rails-log-group-${ENVIRONMENT}",
        "awslogs-stream-prefix": "rails-log-stream-${ENVIRONMENT}"
      }
    }
  }
]