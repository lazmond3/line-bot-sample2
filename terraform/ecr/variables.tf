variable "ecr-name" {
    type = string
}
variable vpc-id {
    type = string
}
variable aws_subnet_private_ids {
    type = list(string)
}
variable vpc_cidr {
    type = string
}