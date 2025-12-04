output "ec2_id" {
  value = aws_instance.web.*.id # Outputting all EC2 instance IDs
}

# output "s3_bucket_name" {
#   value = aws_s3_bucket.name.bucket # Outputting the S3 bucket name
# }



# output "instance_public_ips" {
#   value = aws_instance.web.*.public_ip # Outputting all EC2 instance public IPs
# }

output "resource_name" {
  value = var.instance_tags["Owner"] # Outputting the Owner tag from the map variable
}