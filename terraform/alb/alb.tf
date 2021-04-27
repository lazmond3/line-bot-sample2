

# ここで初めて ELB(ALB?) を 定義できる。 DNS名とかいってたアレはなんだったんだ
# ELB Target Group
# https://www.terraform.io/docs/providers/aws/r/lb_target_group.html
# ALB で定義できるのは、ターゲットグループの定義 すなわちVPCのこと。(forward) 先に指定できる)
# 逆にCloudFront などはredirectじゃないと指定できない気がするけど、その場合画像ファイルとかうまく表示できなくなるのでは？
resource "aws_lb_target_group" "main" {
  name = "${var.app-name}-target-group"

  # ターゲットグループを作成するVPC
  # これ雑じゃない？ どのサブネットに渡すとか
  # どの VPC に渡すか、だけでいいのか？
  vpc_id = var.vpc-id

  # ALBからECSタスクのコンテナへトラフィックを振り分ける設定
  # application load balancer ? 
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  # コンテナへの死活監視設定
  health_check {
    port = 80
    path = "/"
  }
}

# 単純なリダイレクトなので、 LISTENER_RULE が不要
resource "aws_lb_listener" "http_to_https" {
  port     = "80"
  protocol = "HTTP"

  load_balancer_arn = aws_lb.this.arn

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  port     = "443"
  protocol = "HTTPS"

  certificate_arn = var.cert-arn

  load_balancer_arn = aws_lb.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.id
  }
}

resource "aws_lb" "this" {
  load_balancer_type = "application"
  name               = var.app-name

  security_groups = [aws_security_group.alb.id]
  subnets         = var.aws_lb_public_ids
}



# ALB Listener Rule
# https://www.terraform.io/docs/providers/aws/r/lb_listener_rule.html
resource "aws_lb_listener_rule" "main" {
  # ルールを追加するリスナー
  listener_arn = aws_lb_listener.https.arn # これ、default が fixed_response の リスナで、これに追加するということか

  # 受け取ったトラフィックをターゲットグループへ受け渡す
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.id
  }

  # ターゲットグループへ受け渡すトラフィックの条件
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}
