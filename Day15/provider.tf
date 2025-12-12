# Configure Terraform version and required providers
terraform {
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Primary region provider (US East 1)
provider "aws" {
  region = var.primary_region
  alias  = "primary"
}

# Secondary region provider (US West 2)
provider "aws" {
  region = var.secondary_region
  alias  = "secondary"
}