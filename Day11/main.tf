locals {
  formatted_name = lower(replace(var.project_name, " ", "-"))
  tags           = merge(var.default_tags, var.common_tags)
  bucket_name    = replace(trim(lower(var.bucket_name), " "), " ", "-")


  allowed_ports = split(",", var.allowed_ports)
  sg_rules = [for port in local.allowed_ports :
    {
      name        = "port-${port}"
      from_port   = tonumber(port)
      to_port     = tonumber(port)
      protocol    = "tcp"
      description = "Allow traffic on port ${port}"
    }
  ]

  instance_size = lookup(var.instance_sizes, var.environment, "t2.micro")
}

resource "aws_s3_bucket" "buck1" {
  bucket = local.bucket_name
  #   tags   = local.tags
  tags = merge(
    local.tags, { Name = "${local.formatted_name}-bucket" }
  )
}


resource "aws_security_group" "sg1" {
  name        = "${local.formatted_name}-sg"
  description = "Security group for ${local.formatted_name}"

  dynamic "ingress" {
    for_each = local.sg_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
        description = ingress.value.description
    }
  }
}