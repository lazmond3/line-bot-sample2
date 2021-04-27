variable "ecr-name" {}

resource "aws_ecr_repository" "line-bot-sample" {
  name                 = var.ecr-name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}