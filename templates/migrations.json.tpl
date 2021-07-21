[
  {
    "name": "migrations",
    "image": "${ECR_REPOSITORY}",
    "command": ["bundle", "exec", "rake", "db:migrate"],
    "memory": 300,
    "environment": [
      {
        "name": "RAILS_ENV",
        "value": "{ENVIRONMENT}"
      },
      {
        "name": "DATABASE_NAME",
        "value": "${DATABASE_NAME}"
      },
      {
        "name": "DATABASE_USERNAME",
        "value": "${DATABASE_USERNAME}"
      },
      {
        "name": "DATABASE_PASSWORD",
        "value": "${DATABASE_PASSWORD}"
      },
      {
        "name": "DATABASE_HOST",
        "value": "${DATABASE_HOST}"
      },
      {
        "name": "DATABASE_PORT",
        "value": "5432"
      }
    ]
  }
]