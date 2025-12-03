output "ec2_id" {
  value = aws_instance.example.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.example.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.example.arn
}

output "region" {
  value = var.region
}