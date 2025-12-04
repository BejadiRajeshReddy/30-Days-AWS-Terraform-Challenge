variable "environment" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Name        = "Dev-Instance"
    Project     = "TerraformDay10"
    Owner       = "Rajesh"
  }
}

#! complex variable for ingress rules

variable "ingress_rules" {
  description = "List of ingress rules for security groups"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0" ]
      description = "HTTP access from anywhere"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access from anywhere"
    }
  ]
}

