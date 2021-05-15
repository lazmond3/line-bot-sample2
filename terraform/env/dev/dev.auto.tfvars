app_name = "line-bot-sample2"

# route53, cert
app_domain  = "line-bot-sample2.moikilo00.net"
root_domain = "moikilo00.net"

# vpc
vpc_azs                  = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
vpc_public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
vpc_private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]

# ecr_name_sample_nginx   = "line-bot-sample-nginx"
ecr_name         = "line-bot-sample2"
ecr_name_base    = "line-bot-sample2"
project_name_app = "app"
# project_name_bot_server = "bot-server"
template_file_path   = "../../ecs/hello_spring.json.tpl" # main.tf からの相対パス
container_repository = "554506578892.dkr.ecr.ap-northeast-1.amazonaws.com/line-bot-sample2-app"
container_tag        = "0.0.1-c51121e"
container_name       = "line-bot-sample2-app" # でいいのか？
container_port       = "8080"                 # でいいのか？
task_mysql_database  = "linebotsample2database"
task_mysql_user      = "user"
task_db_port         = "3306"
