locals {
  origin_id = "WebsiteBucketOrigin"
}

resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id                = local.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.website_distribution_oac.id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]

    # Use the CachingOptimized managed policy
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-caching-optimized
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
  }

  aliases = [var.domain_name]
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.frontend_cert.arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  # These two custom error responses allows React Router to work.
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }
}

resource "random_integer" "website_oac_name" {
  min = 1000
  max = 10000
}

resource "aws_cloudfront_origin_access_control" "website_distribution_oac" {
  name                              = "WebsiteOAC${random_integer.website_oac_name.result}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

output "website_cloudfront_domain" {
  value = aws_cloudfront_distribution.website_distribution.domain_name
}

output "distribution_id" {
  value = aws_cloudfront_distribution.website_distribution.id
}
