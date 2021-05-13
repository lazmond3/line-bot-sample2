variable "aws_lb_public_ids" {
  type = list(string) # aws_subnet.publics.*.id
}
variable "app_name" {
  type = string # line-bot-sample2
}
variable "vpc_id" {
  type = string
}
