resource "aws_cloudwatch_log_group" "line-bot-sample2" {
  name = "/aws/ecs/${var.app_name}"

  tags = {
    Name = "${var.app_name}"
  }

}

# デバッグ用 python2
resource "aws_cloudwatch_log_group" "python2" {
  name = "/aws/ecs/${var.app_name}/python2"
  # name = "/aws/ecs/python2"

  tags = {
    Name = "linebot2-python2"
  }
}
