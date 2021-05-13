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

# module "ecr-app" {
#   source                          = "../../ecr"
#   ecr-name                        = "${var.ecr_name2}-${var.project_name_app}"
#   vpc_id                          = module.vpc.vpc_id
#   aws_subnet_private_ids          = module.vpc.aws_subnet_private_ids
#   vpc_cidr                        = module.vpc.vpc_cidr
#   aws_route_table_ids_for_private = module.vpc.aws_route_table_ids_for_private
# }

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
# module "rds" {
#   app_name                       = var.app_name
#   source                         = "../../rds"
#   vpc_id                         = module.vpc.vpc_id
#   aws_lb_public_ids              = module.vpc.aws_subnet_public_ids
#   aws_lb_private_ids             = module.vpc.aws_subnet_private_ids
#   vpc_cidr                       = module.vpc.vpc_cidr
#   debug_ec2_aws_route_table_id_0 = module.vpc.aws_route_table_ids_for_private[0]
#   mysql_database                 = var.mysql_database
#   mysql_password                 = var.mysql_password
#   mysql_user                     = var.mysql_user
#   ecs_task_execution_role_id     = module.ecs.ecs_task_execution_role_id
# }
