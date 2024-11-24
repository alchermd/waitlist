resource "aws_s3_bucket" "website_bucket" {
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront_distribution" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.allow_access_cloudfront_distribution.json
}

data "aws_iam_policy_document" "allow_access_cloudfront_distribution" {
  statement {
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]

    condition {
      test     = "StringEquals"
      values   = [aws_cloudfront_distribution.website_distribution.arn]
      variable = "AWS:SourceArn"
    }
  }
}

output "website_bucket_name" {
  value = aws_s3_bucket.website_bucket.id
}
