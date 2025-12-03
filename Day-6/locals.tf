locals {
  bucket_name = "${var.environment}-bucket-${var.region}"

  common_tags = {
    Environment = var.environment
    Region      = var.region
    Name        = "${var.environment}-resources"
    owner       = "DevOps Team"
  }
}

