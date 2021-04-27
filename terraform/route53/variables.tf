variable "app-domain" {
  description = "これから取得したいドメイン名"
  type        = string
}
variable "root-domain" {
  description = "Route 53 で管理しているルートドメイン名 (wildcard)"
  type        = string
}

variable "lb_dns_name" {
    type = string # aws_lb.this.dns_name
}
variable "lb_zone_id" {
    type = string # aws_lb.this.zone_id
}
