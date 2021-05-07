terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "remote" {
    organization = "line-bot-sample2"
    workspaces {
      name = "line-bot-sample2"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "ecr-app" {
  source                          = "../../ecr"
  ecr-name                        = "${var.ecr_name2}-${var.project_name_app}"
  vpc_id                          = module.vpc.vpc_id
  aws_subnet_private_ids          = module.vpc.aws_subnet_private_ids
  vpc_cidr                        = module.vpc.vpc_cidr
  aws_route_table_ids_for_private = module.vpc.aws_route_table_ids_for_private
}

# module "ecr-bot-server" {
#   source   = "../../ecr"
#   ecr-name = "${var.ecr_name2}-${var.project_name_bot_server}"
# }

module "route53" {
  source          = "../../route53"
  root_domain     = var.root_domain
  app_domain      = var.app_domain
  aws_lb_dns_name = module.alb.aws_lb_dns_name
  aws_lb_zone_id  = module.alb.aws_lb_zone_id
}

module "vpc" {
  source   = "../../vpc"
  app_name = var.app_name
}

module "alb" {
  source            = "../../alb"
  aws_lb_public_ids = module.vpc.aws_subnet_public_ids
  app_name          = var.app_name
  vpc_id            = module.vpc.vpc_id
  cert-arn          = module.route53.cert-arn
  ecs-id            = module.ecs.ecs-id
}

module "ecs" {
  source                       = "../../ecs"
  app_name                     = var.app_name
  vpc_id                       = module.vpc.vpc_id
  ecs_load_balancer_target_arn = module.alb.aws_lb_target_group_main_arn
  ecs_subnets                  = module.vpc.aws_subnet_private_ids
  template_file_path           = var.template_file_path
  container_repository         = var.container_repository
  container_tag                = var.container_tag
  container_name               = var.container_name
  container_port               = var.container_port
  aws_ecr_repository_name      = module.ecr-app.aws_ecr_repository_name
}

# rds をやってみる
module "rds" {
  source                         = "../../rds"
  vpc_id                         = module.vpc.vpc_id
  aws_lb_public_ids              = module.vpc.aws_subnet_public_ids
  aws_lb_private_ids             = module.vpc.aws_subnet_private_ids
  vpc_cidr                       = module.vpc.vpc_cidr
  debug_ec2_aws_route_table_id_0 = module.vpc.aws_route_table_ids_for_private[0]
  mysql_database                 = var.mysql_database
}
