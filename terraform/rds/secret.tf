resource "aws_ssm_parameter" "database_user" {
  name  = "MYSQL_USER"
  type  = "String"
  value = "MYSQL_USER"
}

resource "aws_ssm_parameter" "database_password" {
  name  = "MYSQL_PASSWORD"
  type  = "String"
  value = "MYSQL_PASSWORD" # TODO: FIX これTF_VAR_由来にしたい.
}
