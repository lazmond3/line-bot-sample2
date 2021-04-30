output "vpc-id" {
    value = aws_vpc.main.id
}
output "aws_subnet_public_ips" {
    value = aws_subnet.publics.*.id
}
output "aws_subnet_private_ips" {
    value = aws_subnet.privates.*.id
}

output "vpc_cidr" {
    value = var.vpc_cidr
}