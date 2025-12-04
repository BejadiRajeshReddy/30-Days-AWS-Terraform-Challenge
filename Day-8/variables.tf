variable "environment" {
  description = "The environment for the S3 bucket"
  type        = string
  default     = "development"
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_names" {
  description = "The name of the S3 bucket"
  type        = list(string)
  default     = ["my-list-bucket-day08-12345", "my-list-bucket-day08-67890"]
}

variable "bucket_name_set" {
  description = "A set of unique S3 bucket names"
  type        = set(string)
  default     = ["my-set-bucket-day08-12345", "my-set-bucket-day08-67890"]
}

variable "tags" {
  description = "A map of tags to assign to the S3 bucket"
  type        = map(string)
  default = {
    Name        = "Day-8-S3-Bucket"
    Environment = "development"
    Project     = "30-Days-AWS-Terraform-Challenge"
  }
}
