terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "moikilo00-tfstate-bucket"
    key    = "line-bot-sample2/dev.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "cert" {
  source      = "../../cert"
  root_domain = var.root_domain
  app_domain  = var.app_domain
  # aws_lb_dns_name = module.alb.aws_lb_dns_name
  # aws_lb_zone_id  = module.alb.aws_lb_zone_id
}

module "vpc" {
  source                   = "../../vpc"
  app_name                 = var.app_name
  vpc_azs                  = var.vpc_azs
  vpc_cidr                 = var.vpc_cidr
  vpc_public_subnet_cidrs  = var.vpc_public_subnet_cidrs
  vpc_private_subnet_cidrs = var.vpc_private_subnet_cidrs
}

module "alb" {
  source            = "../../alb"
  aws_lb_public_ids = module.vpc.vpc_aws_subnet_public_ids
  app_name          = var.app_name
  vpc_id            = module.vpc.vpc_id
  cert_arn          = module.cert.cert_arn
  sg_alb_id         = module.security.sg_alb_id
}

module "security" {
  source   = "../../security"
  vpc_id   = module.vpc.vpc_id
  app_name = var.app_name
}

module "route53" {
  source                    = "../../route53"
  app_domain                = var.app_domain
  cert_route53_zone_main_id = module.cert.cert_route53_zone_main_id
  alb_dns_name              = module.alb.alb_dns_name
  alb_zone_id               = module.alb.alb_zone_id
}

module "ecr" {
  source   = "../../ecr"
  ecr_name = "${var.ecr_name_base}-${var.project_name_app}"
}

# ここまで実装した
# module "vpc_endpoint" {
#   source                                  = "../../vpc_endpoint"
#   vpc_id                                  = module.vpc.vpc_id
#   vpc_cidr                                = var.vpc_cidr
#   vpc_aws_subnet_private_ids              = module.vpc.vpc_aws_subnet_private_ids
#   vpc_aws_route_table_id_for_private_list = module.vpc.vpc_aws_route_table_id_for_private_list
# }


# ここまで実装した
# -------------------------------------------
module "cloudwatch" {
  source   = "../../cloudwatch"
  app_name = var.app_name
}
module "ecs" {
  source                                         = "../../ecs"
  app_name                                       = var.app_name
  template_file_path                             = var.template_file_path
  ecs_load_balancer_target_arn                   = module.alb.alb_target_group_main_arn
  ecs_subnets                                    = module.vpc.vpc_aws_subnet_private_ids
  container_name                                 = var.container_name
  container_port                                 = var.container_port
  container_repository                           = var.container_repository
  container_tag                                  = var.container_tag
  aws_ecr_repository_name                        = module.ecr.aws_ecr_repository_name
  aws_ssm_parameter_database_password_secret_arn = module.ssm.aws_ssm_parameter_database_password_secret_arn
  aws_cloudwatch_log_group_main_name             = module.cloudwatch.aws_cloudwatch_log_group_main_name
  task_mysql_database                            = var.task_mysql_database
  task_mysql_user                                = var.task_mysql_user
  task_db_address                                = module.rds.db_address
  task_db_port                                   = var.task_db_port
  aws_security_group_ecs_id                      = module.security.aws_security_group_ecs_id
  ecs_task_execution_role_arn                    = module.iam.ecs_task_execution_role_arn
}

module "iam" {
  source                                         = "../../iam"
  app_name                                       = var.app_name
  vpc_id                                         = module.vpc.vpc_id
  aws_cloudwatch_log_group_main_arn              = module.cloudwatch.aws_cloudwatch_log_group_main_name
  aws_ssm_parameter_database_password_secret_arn = module.ssm.aws_ssm_parameter_database_password_secret_arn
  ecs_task_execution_role_id                     = module.iam.aws_iam_role_ecs_task_execution_role_id
}

module "ssm" {
  source         = "../../ssm"
  mysql_password = var.mysql_password
}


# module "ecs" {
#   source                                         = "../../ecs"
#   app_name                                       = var.app_name
#   vpc_id                                         = module.vpc.vpc_id
#   ecs_load_balancer_target_arn                   = module.alb.aws_lb_target_group_main_arn
#   ecs_subnets                                    = module.vpc.aws_subnet_private_ids
#   template_file_path                             = var.template_file_path
#   container_repository                           = var.container_repository
#   container_tag                                  = var.container_tag
#   container_name                                 = var.container_name
#   container_port                                 = var.container_port
#   aws_ecr_repository_name                        = module.ecr-app.aws_ecr_repository_name
#   aws_ssm_parameter_database_password_secret_arn = module.rds.aws_ssm_parameter_database_password_secret_arn
#   mysql_database                                 = var.mysql_database
#   mysql_user                                     = var.mysql_user
#   db_address                                     = module.rds.db_address
#   db_port                                        = module.rds.db_port
# }

# rds をやってみる
module "rds" {
  app_name           = var.app_name
  source             = "../../rds"
  vpc_id             = module.vpc.vpc_id
  aws_lb_public_ids  = module.vpc.vpc_aws_subnet_public_ids
  aws_lb_private_ids = module.vpc.vpc_aws_subnet_private_ids
  vpc_cidr           = var.vpc_cidr
  # debug_ec2_aws_route_table_id_0 = module.vpc.aws_route_table_ids_for_private[0]
  mysql_password             = var.mysql_password
  mysql_database             = var.task_mysql_database
  mysql_user                 = var.task_mysql_user
  ecs_task_execution_role_id = module.iam.aws_iam_role_ecs_task_execution_role_id
}
