variable "template-file-path" {
  type = string
  default = "./ecs/nginx_template.json"
}

variable "app-name" {
    type = string
}
# variable "aws_ecs_services_depends_on" {    
#     type = list(resource) # これできるのか
#     # aws_lb_listener_rule.main 
# }
variable vpc-id {
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
    default = "nginx"
    type = string
}
variable "container_port" {
    default = "80"
}

variable container_repository {
    type = string
}

variable container_tag {
    type = string
}

variable aws_ecr_repository_name {
    type = string
}
