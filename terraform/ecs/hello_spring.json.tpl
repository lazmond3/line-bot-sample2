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
        "name": "DB_PASSWORD",
        "valueFrom": "${database_password}"
      }
    ],
    "environment": [
      {
        "name": "DB_DATABASE",
        "value": "${mysql_database}"
      },
      {
        "name": "DB_USER",
        "value": "${mysql_user}"
      },
      {
        "name": "DB_ADDRESS",
        "value": "${db_address}"
      },
      {
        "name": "DB_PORT",
        "value":  "${db_port}"
      }
    ]
  }
]
