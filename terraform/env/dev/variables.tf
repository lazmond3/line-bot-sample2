variable "app_name" {
  type = string
}
variable "ecr_name_sample_nginx" {
  type = string
}
variable "ecr_name2" {
  type = string
}
variable "project_name_app" {
  type = string
}
variable "project_name_bot_server" {
  type = string
}
variable "root_domain" {
  type = string
}
variable "app_domain" {
  type = string
}
variable "template_file_path" {
  type = string
}

variable "container_repository" {
  type = string
}
variable "container_name" {
  type = string
}
variable "container_port" {
  type = string
}

variable "container_tag" {
  type = string
}

# secret
## これは secret じゃない
variable "mysql_database" {
  type = string
}
variable "mysql_user" {
  type = string
}

# TF_VAR_mysql_password で渡す
variable "mysql_password" {
  type = string
}
