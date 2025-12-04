# Meta-Arguments in Terraform (count and for_each)


# Using COUNT meta-argument to create S3 buckets

resource "aws_s3_bucket" "bucket_count" {
  count  = length(var.bucket_names)
  bucket = var.bucket_names[count.index]
  tags   = var.tags

  # depends_on meta-argument
  # bucket_count resource will be created only after bucket_foreach resource is created 
  # bucket_count is dependent on bucket_foreach
  depends_on = [aws_s3_bucket.bucket_foreach]
}

# Using FOR_EACH meta-argument to create S3 buckets

resource "aws_s3_bucket" "bucket_foreach" {
  for_each = var.bucket_name_set
  bucket   = each.value
  tags     = var.tags
}


