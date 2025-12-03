#? Declare variable types here; actual values are supplied via .tfvars files
#! String type

variable "environment" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  description = "The type of instance to use"
  type        = string
}

#! Number type

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
}

variable "storage_size" {
  description = "Size of the storage in GB"
  type        = number
}

#! Boolean type
variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
}

#! List type
variable "cidr_block" {
  description = "List of CIDR blocks for security group rules"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "allowed_vm_types" {
  description = "List of allowed VM instance types"
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}

#! Set type
variable "allowed_regions" {
  description = "List of allowed AWS regions"
  type        = set(string)
  default     = ["us-east-1", "us-west-2", "eu-east-1", "eu-east-1"] # "eu-east-1" is duplicated to show set behavior 
  # Sets are unordered (no indexing). Terraform may display elements in alphabetical order
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = set(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1a"] # "us-east-1a" is duplicated to show set behavior
}

#! Map type
variable "instance_tags" {
  description = "Map of tags to assign to the instances"
  type        = map(string)
  default = {
    Owner       = "DevOpsTeam"
    Project     = "TerraformChallenge"
    Environment = "Development"
  }
}

#! Tuple type
variable "ingress_rules" {
  description = "Tuple defining ingress rules: [from_port, to_port, protocol]"
  type        = tuple([number, string, number])
  default     = [443, "tcp", 443]

}

#! Object type
variable "config" {
  description = "Object variable for complex configuration"
  type = object({
    instance_count    = number
    instance_type     = string
    region            = string
    enable_monitoring = bool
  })
  default = {
    instance_count    = 1
    instance_type     = "t2.micro"
    region            = "us-east-1"
    enable_monitoring = false
  }
}



