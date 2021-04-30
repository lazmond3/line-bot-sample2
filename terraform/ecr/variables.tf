variable "ecr-name" {
  type = string
}
variable "vpc-id" {
  type = string
}
variable "aws_subnet_private_ips" {
  type = list(string)
}
variable "vpc_cidr" {
  type = string
}

variable "route_table_ids_for_private" {
  type = list(string)
}
