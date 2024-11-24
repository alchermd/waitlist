

resource "aws_acm_certificate" "frontend_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  provider          = aws.virginia
}

resource "aws_acm_certificate_validation" "frontend_cert_validation" {
  certificate_arn         = aws_acm_certificate.frontend_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.frontend_cert_validation : record.fqdn]
  provider                = aws.virginia
}
