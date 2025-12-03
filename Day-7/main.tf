# S3 Bucket Resource
# resource "aws_s3_bucket" "name" {
#   bucket = local.bucket_name
#   tags = {
#     Name        = local.bucket_name
#     Environment = var.environment
#   }
# }


# Ec2 Instance Resource
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"        # Example AMI ID for Amazon Linux 2 in us-east-1  
  instance_type = var.allowed_vm_types[2]        # Using 3rd element from the list variable
  count         = var.instance_count             # Number variable   
  availability_zone = tolist(var.availability_zones)[0] # set variable converted to list to access 1st element

  monitoring                  = var.config.enable_monitoring         # Object variable
  associate_public_ip_address = var.associate_public_ip              # Boolean variable

  #   tags = var.instance_tags
  #   Merging map variable with name tag to give unique names to each instance
  tags = merge(
    var.instance_tags,
    { Name = "web-${count.index}" }
  )

}

# Security Group Resource

resource "aws_security_group" "web_sg" {
  name        = "${var.environment}-web-sg"
  description = "Allow HTTP inbound & outbound traffic"

  # Allow inbound HTTP traffic
  ingress {
    from_port   = var.ingress_rules[0]      # Using Tuple variable 
    protocol    = var.ingress_rules[1]    
    to_port     = var.ingress_rules[2]      
    cidr_blocks = [var.cidr_block[1]] # Using 2nd element from the list variable
  }

  # Allow outbound HTTP traffic
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-web-sg"
    Environment = var.environment
  }
}

# Alternative way to define security group rules using separate resources

# resource "aws_vpc_security_group_ingress_rule" "http_ingress" {
#   security_group_id = aws_security_group.web_sg.id
#   cidr_ipv4         = var.cidr_block[1]
#   from_port         = 80
#   to_port           = 80
#   ip_protocol       = "tcp"
# }

# resource "aws_vpc_security_group_egress_rule" "http_egress" {
#   security_group_id = aws_security_group.web_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   to_port           = 80
#   ip_protocol       = "tcp"
# }
