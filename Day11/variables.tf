variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "Project ABC Management"

}

variable "default_tags" {
  type = map(string)
  default = {
    created_by = "Terraform"
    Owner      = "DevOps Team"
  }
}

variable "common_tags" {
  type = map(string)
  default = {
    Environment = "Development"
    Department  = "IT"
  }
}

variable "bucket_name" {
  default = "  The Project Day 10  "
}

variable "allowed_ports" {
  default = "22,80,443"
}

variable "environment" {
  default = "dev"
}

variable "instance_sizes" {
  default = {
    dev   = "t2.small"
    staging   = "t2.small"
    prod    = "t3.micro"
  }
}