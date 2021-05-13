# alb のため
output "cert_arn" {
  value = aws_acm_certificate.main.arn
}

# route53 のため
output "cert_route53_zone_main_id" {
  value = data.aws_route53_zone.main.id
}
