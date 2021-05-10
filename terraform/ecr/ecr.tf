resource "aws_ecr_repository" "main" {
  name                 = var.ecr-name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# app2 for connectivity check
resource "aws_ecr_repository" "app2" {
  name                 = "line-bot-sample2-app2"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
