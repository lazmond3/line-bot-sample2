[
  {
    "name": "linebot-sample2-hello-app",
    "image": "${container_repository}:${container_tag}",
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 80
      }
    ]
  }
]
