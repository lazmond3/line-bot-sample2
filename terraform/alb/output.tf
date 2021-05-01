output "aws_lb_dns_name" {
  value = aws_lb.this.dns_name
}
output "aws_lb_zone_id" {
  value = aws_lb.this.zone_id
}
output "aws_lb_listener_rule_resource" {
  value = aws_lb_listener_rule.main
}
output "aws_lb_target_group_main_arn" {
  value = aws_lb_target_group.main.arn
}
