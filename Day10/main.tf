#? Terraform Expressions
#! Conditional Expressions 

# resource "aws_instance" "example" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   count         = var.instance_count
#   instance_type = var.environment == "dev" ? "t2.micro" : "t3.micro"

#   tags = var.tags
# }

#! Dynamic block Expression 
# resource "aws_security_group" "dynamic_ingress" {
#   name = "sgs"

#   dynamic "ingress" {
#     for_each = var.ingress_rules
#     content {
#       from_port   = ingress.value.from_port
#       to_port     = ingress.value.to_port
#       protocol    = ingress.value.protocol
#       cidr_blocks = ingress.value.cidr_blocks
#       description = ingress.value.description
#     }
#   }

#   tags = var.tags
# }

#! Splat Expression
resource "aws_instance" "splat_example" {
  ami           = "ami-0c55b159cbfafe1f0"
  count         = 2
  instance_type = "t2.micro"
  tags          = var.tags
}

locals {
  # Splat expression to get all instance IDs
  aws_instance_ids = aws_instance.splat_example[*].id

  # Splat expression to get all public and private IPs
  all_public_ips  = aws_instance.splat_example[*].public_ip
  all_private_ips = aws_instance.splat_example[*].private_ip
}

output "instance_ids" {
  value = local.aws_instance_ids
}

output "public_ips" {
  value = local.all_public_ips
}

output "private_ips" {
  value = local.all_private_ips
}