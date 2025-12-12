


variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name for static website"
  type        = string
  default     = "my-terraform-static-website-101"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "StaticWebsite"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}



