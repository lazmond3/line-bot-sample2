variable "aws_lb_public_ids" {
  type = list(string) # aws_subnet.publics.*.id
}
variable "app-name" {
  type = string # line-bot-sample2
}
variable "vpc-id" {
  type = string # aws_vpc.main.id
}

variable "cert-arn" {
  type = string
}