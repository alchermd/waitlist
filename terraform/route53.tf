

resource "aws_route53_zone" "main" {
  name = var.route53_zone_name
}

import {
  to = aws_route53_zone.main
  id = var.route53_zone_id
}

resource "aws_route53_record" "apex" {
  zone_id = aws_route53_zone.main.id
  name    = var.route53_a_record
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "frontend_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.frontend_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  records         = [each.value.record]
  allow_overwrite = true
  name            = each.value.name
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.id
}

