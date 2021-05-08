[
  {
    "name": "${container_name}",
    "image": "${container_repository}:${container_tag}",
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "secrets": [
      {
        "name": "MYSQL_PASSWORD",
        "valueFrom": "${database_password}"
      }
    ],
    "environment": [
      {
        "name": "MYSQL_DATABASE",
        "value": "${mysql_database}"
      },
      {
        "name": "MYSQL_USER",
        "value": "${mysql_user}"
      }
    ]
  }
]
