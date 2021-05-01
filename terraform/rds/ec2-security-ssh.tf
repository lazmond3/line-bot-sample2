resource "aws_security_group" "ec2_public_bastian" {
  name   = "ec2_bastian"
  vpc_id = var.vpc-id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # 本当は 0.0.0.0 で設定してみてもいいけど
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_security_group" "mysql_to_private" {
  name   = "mysql_to_private"
  vpc_id = var.vpc-id

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # 本当は 0.0.0.0 で設定してみてもいいけど
  }
}
