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

module "ecr-app" {
  source                          = "../../ecr"
  ecr-name                        = "${var.ecr-name2}-${var.project-name-app}"
  vpc_id                          = module.vpc.vpc_id
  aws_subnet_private_ids          = module.vpc.aws_subnet_private_ids
  vpc_cidr                        = module.vpc.vpc_cidr
  aws_route_table_ids_for_private = module.vpc.aws_route_table_ids_for_private
}

# module "ecr-bot-server" {
#   source   = "../../ecr"
#   ecr-name = "${var.ecr-name2}-${var.project-name-bot-server}"
# }

module "route53" {
  source          = "../../route53"
  root-domain     = var.root-domain
  app-domain      = var.app-domain
  aws_lb_dns_name = module.alb.aws_lb_dns_name
  aws_lb_zone_id  = module.alb.aws_lb_zone_id
}

module "vpc" {
  source   = "../../vpc"
  app-name = var.app-name
}

module "alb" {
  source            = "../../alb"
  aws_lb_public_ids = module.vpc.aws_subnet_public_ids
  app-name          = var.app-name
  vpc_id            = module.vpc.vpc_id
  cert-arn          = module.route53.cert-arn
  ecs-id            = module.ecs.ecs-id
}

module "ecs" {
  source                       = "../../ecs"
  app-name                     = var.app-name
  vpc_id                       = module.vpc.vpc_id
  ecs_load_balancer_target_arn = module.alb.aws_lb_target_group_main_arn
  ecs_subnets                  = module.vpc.aws_subnet_private_ids
  template-file-path           = var.template-file-path
  container_repository         = var.container_repository
  container_tag                = var.container_tag
  container_name               = var.container_name
  container_port               = var.container_port
  aws_ecr_repository_name      = module.ecr-app.aws_ecr_repository_name
}

# rds をやってみる
module "rds" {
  source             = "../../rds"
  vpc-id             = module.vpc.vpc-id
  aws_lb_public_ids  = module.vpc.aws_subnet_public_ips
  aws_lb_private_ids = module.vpc.aws_subnet_private_ips
  vpc_cidr           = module.vpc.vpc_cidr
}
