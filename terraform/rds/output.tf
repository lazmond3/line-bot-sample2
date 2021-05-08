output "aws_ssm_parameter_database_password_secret_arn" {
  value = aws_ssm_parameter.database_password_secret.arn
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster#endpoint
output "db_address" {
  value = aws_rds_cluster.this.endpoint
}
output "db_port" {
  value = aws_rds_cluster.this.port
}
