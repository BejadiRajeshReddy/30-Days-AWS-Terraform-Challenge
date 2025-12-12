# Local variable for CloudFront origin ID
locals {
  origin_id = "S3-${aws_s3_bucket.website.id}"
}