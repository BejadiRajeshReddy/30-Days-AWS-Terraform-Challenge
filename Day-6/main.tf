resource "aws_s3_bucket" "example" {
  bucket = local.bucket_name

    tags = {
        Name        = local.common_tags.Name
        Owner       = local.common_tags.owner
        Environment = local.common_tags.Environment
        Region      = local.common_tags.Region
    }
}

resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
    instance_type = "t2.micro"

    tags = local.common_tags
}