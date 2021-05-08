data "template_file" "container_definitions" {
  template = file(var.template_file_path)
  vars = {
    container_name       = var.container_name
    container_repository = var.container_repository
    container_tag        = var.container_tag
    # database_password    = aws_secretsmanager_secret.database_password_secret.arn
    # database_password    = aws_ssm_parameter.database_password_secret.arn
    database_password = var.aws_ssm_parameter_database_password_secret_arn
    mysql_database    = var.mysql_database
    mysql_user        = var.mysql_user
  }
}
