variable "template-file-path" {
  type = string
}

variable "app-name" {
  type = string
}
# variable "aws_ecs_services_depends_on" {    
#     type = list(resource) # これできるのか
#     # aws_lb_listener_rule.main 
# }
variable "vpc-id" {
  type = string
}
variable "ecs_desired_count" {
  default = "1"
}
variable "ecs_load_balancer_target_arn" {
  type = string
  # aws_lb_target_group.main.arn
}
variable "ecs_subnets" {
  type = list(string) # aws_subnet.privates.*.id
}
variable "container_name" {
  type = string
}
variable "container_port" {
  type = string
}

variable "container_repository" {
  type = string
}

variable "container_tag" {
  type = string
}

variable "aws_ecr_repository_name" {
  type = string
}
