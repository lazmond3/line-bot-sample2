variable "vpc_id" {
  type = string
}

variable "aws_lb_public_ids" {
  type = list(string)
}
variable "aws_lb_private_ids" {
  type = list(string)
}
variable "vpc_cidr" {
  type = string
}
variable "debug_ec2_aws_route_table_id_0" {
  type = string
}
