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
        "name": "JDBC_PASSWORD",
        "valueFrom": "${database_password}"
      }
    ],
    "environment": [
      {
        "name": "MYSQL_DATABASE",
        "value": "${mysql_database}"
      },
      {
        "name": "JDBC_USER",
        "value": "${mysql_user}"
      },
      {
        "name": "JDBC_URL",
        "value": "jdbc:mysql://address=(host=${db_address})(port=${db_port})/${mysql_database}"
      }
    ]
  }
]
