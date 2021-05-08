resource "aws_cloudwatch_log_group" "line-bot-sample2" {
  name = "/aws/ecs/${var.app_name}"

  tags = {
    Name = "${var.app_name}"
  }
}
