app-name    = "line-bot-sample2"
app-domain  = "line-bot-sample2.moikilo00.net"
root-domain = "moikilo00.net"

ecr-name-sample-nginx   = "line-bot-sample-nginx"
ecr-name2               = "line-bot-sample2"
project-name-app        = "app"
project-name-bot-server = "bot-server"
template-file-path      = "../../ecs/hello_spring.json.tpl" # main.tf からの相対パス
container_repository    = "554506578892.dkr.ecr.ap-northeast-1.amazonaws.com/line-bot-sample2-app"
container_tag           = "0.0.1-75b03b2"
container_name          = "line-bot-sample2-app" # でいいのか？
container_port          = "8080"                 # でいいのか？
