# ACM
# https://www.terraform.io/docs/providers/aws/r/acm_certificate.html
# cloudfront で使いたい場合は、 us- に設定する。
resource "aws_acm_certificate" "main" {
  domain_name = var.app_domain

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# ACM Validate
# https://www.terraform.io/docs/providers/aws/r/acm_certificate_validation.html
resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.validations : record.fqdn]
}
