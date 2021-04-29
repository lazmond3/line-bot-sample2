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
  source   = "../../ecr"
  ecr-name = "${var.ecr-name2}-${var.project-name-app}"
}
module "ecr-bot-server" {
  source   = "../../ecr"
  ecr-name = "${var.ecr-name2}-${var.project-name-bot-server}"
}

module "route53" {
  source      = "../../route53"
  root-domain = var.root-domain
  app-domain  = var.app-domain
  lb_dns_name = module.alb.lb_dns_name
  lb_zone_id  = module.alb.lb_zone_id
}

module "vpc" {
  source   = "../../vpc"
  app-name = var.app-name
}

module "alb" {
  source            = "../../alb"
  aws_lb_public_ids = module.vpc.aws_subnet_public_ips
  app-name          = var.app-name
  vpc-id            = module.vpc.vpc-id
  cert-arn          = module.route53.cert-arn
}

module "ecs" {
  source                       = "../../ecs"
  app-name                     = var.app-name
  vpc-id                       = module.vpc.vpc-id
  ecs_load_balancer_target_arn = module.alb.aws_lb_target_arn
  ecs_subnets                  = module.vpc.aws_subnet_private_ips
  template-file-path           = var.template-file-path
  container_repository         = var.container_repository
  container_tag                = var.container_tag
  container_name               = var.container_name
  container_port               = var.container_port
  aws_ecr_repository_name      = module.ecr-app.aws_ecr_repository_name
}
