app_name    = "line-bot-sample2"
app_domain  = "line-bot-sample2.moikilo00.net"
root_domain = "moikilo00.net"

ecr_name_sample_nginx   = "line-bot-sample-nginx"
ecr_name2               = "line-bot-sample2"
project_name_app        = "app"
project_name_bot_server = "bot-server"
template_file_path      = "../../ecs/hello_spring.json.tpl" # main.tf からの相対パス
container_repository    = "554506578892.dkr.ecr.ap-northeast-1.amazonaws.com/line-bot-sample2-app"
container_tag           = "0.0.1-5191cf8"
container_name          = "line-bot-sample2-app" # でいいのか？
container_port          = "8080"                 # でいいのか？
mysql_database = "linebotsample2database"
