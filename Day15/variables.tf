# Region Variables
variable "primary_region" {
  description = "Primary AWS region for VPC deployment"
  type        = string
  default     = "us-east-1"
  
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.primary_region))
    error_message = "Region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "secondary_region" {
  description = "Secondary AWS region for VPC deployment"
  type        = string
  default     = "us-west-2"
  
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.secondary_region))
    error_message = "Region must be a valid AWS region format (e.g., us-west-2)."
  }
}

# VPC CIDR Blocks
variable "primary_vpc_cidr" {
  description = "CIDR block for primary VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
  description = "CIDR block for secondary VPC"
  type        = string
  default     = "10.1.0.0/16"
}

# Subnet CIDR Blocks
variable "primary_subnet_cidr" {
  description = "CIDR block for primary subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "secondary_subnet_cidr" {
  description = "CIDR block for secondary subnet"
  type        = string
  default     = "10.1.1.0/24"
}

# Instance Configuration
variable "instance_type" {
  description = "EC2 instance type for demo servers"
  type        = string
  default     = "t2.micro"
  
  validation {
    condition     = contains(["t2.micro", "t2.small", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Instance type must be a valid t2/t3 type eligible for free tier."
  }
}

# SSH Key Names
variable "primary_key_name" {
  description = "Name of SSH key pair in primary region"
  type        = string
}

variable "secondary_key_name" {
  description = "Name of SSH key pair in secondary region"
  type        = string
}

# Tags
variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "vpc-peering-mini-project-2"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}