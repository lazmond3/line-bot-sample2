# VPC 変数
variable "vpc_id" {
  type = string
}
variable "vpc_cidr" {
    type = string
}
variable "aws_subnet_public_ids" {
  type = list(string)
}
variable "aws_subnet_private_ids" {
  type = list(string)
}

variable "aws_route_table_ids_for_private" {
  value = aws_route_table.privates.*.id
}


# ロードバランサ
variable "aws_lb_dns_name" {
  type = string
}
variable "aws_lb_zone_id" {
  type = string
}
variable "aws_lb_target_group_main_arn" {
  type = string
}
