terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "ecr" {
  source   = "./ecr"
  ecr-name = var.ecr-name
}

module "route53" {
  source      = "./route53"
  root-domain = var.root-domain
  app-domain  = var.app-domain
  lb_dns_name = module.alb.lb_dns_name
  lb_zone_id  = module.alb.lb_zone_id
}

module "vpc" {
  source   = "./vpc"
  app-name = var.app-name
}

module "alb" {
  source            = "./alb"
  aws_lb_public_ids = module.vpc.aws_subnet_public_ips
  app-name          = var.app-name
  vpc-id            = module.vpc.vpc-id
  cert-arn          = module.route53.cert-arn
}

module "ecs" {
  source   = "./ecs"
  app-name = var.app-name
  # aws_ecs_services_depends_on = [module.alb.aws_lb_listener_rule_resource]
  vpc-id                       = module.vpc.vpc-id
  ecs_load_balancer_target_arn = module.alb.aws_lb_target_arn
  ecs_subnets                  = module.vpc.aws_subnet_private_ips
  # template-file-path = var.template-file-path
}