terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# 1. Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name = "my-vpc"
  }
}

# 2. Create an S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-tf-bucket-day3-unique-123456"     # Must be globally unique

  tags = {
    Name   = "my-bucket"
    Environment = "Dev"
    # Implicit dependency — using VPC ID as a tag
    VPC_ID = aws_vpc.my_vpc.id 
  }
}