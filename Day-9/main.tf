#! create_before_destroy

# resource "aws_instance" "web_server" {
#   # ami           = "ami-0ff8a91507f77f867" # Amazon Linux 2 AMI 
#   ami           = "ami-0c2b8ca1dad447f8a"   # change to ami or instance type for lifecycle testing 
#   instance_type = "t3.micro"

#   user_data = <<-EOF
#     #!/bin/bash
#     apt-get update
#     apt-get install -y apache2
#     echo "Hello from Web Server" > /var/www/html/index.html
#     systemctl start apache2
#   EOF

#   lifecycle {
#     create_before_destroy = true
#   }

#   vpc_security_group_ids = [aws_security_group.web_sg.id]

#   tags = {
#     Name = "production-web-server"
#   }
# }

# resource "aws_security_group" "web_sg" {
#   name = "web-sg"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }



# #! prevent_destroy
# resource "aws_s3_bucket" "prod_data" {
#   bucket = "my-production-data-bucket"

#   lifecycle {
#     # prevent_destroy = true
#   }
# }


#! ignore_changes

# resource "aws_instance" "example" {
#   ami           = "ami-0c7217cdde317cfec"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "MyServer"
#   }

#   lifecycle {
#     ignore_changes = [
#       tags["Name"]
#     ]
#   }
# }

#! replaced_triggered_by

# resource "aws_security_group" "web_sg" {
#   name        = "app-security-group"
#   description = "Security group for application servers"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/8"]
#   }
# }

# resource "aws_instance" "web_with_sg" {
#   instance_type = "t2.micro"
#   ami           = "ami-0ff8a91507f77f867"

#   vpc_security_group_ids = [aws_security_group.web_sg.id]   # without this line, the replace_triggered_by won't work

#   lifecycle {
#     replace_triggered_by = [aws_security_group.web_sg]
#   }

#   tags = {
#     Name = "DBServer"
#   }

# }


#! precondition

# resource "aws_instance" "web" {
#   instance_type = "t2.micro"

#   lifecycle {
#     precondition {
#       condition     = instance_type != "t2.micro"
#       error_message = "t2.micro is not allowed for production workloads."
#     }
#   }
# }



#! postconditions

# resource "aws_s3_bucket" "main" {
#   bucket = "my-unique-bucket-name-123456"

#   tags = {
#     Name        = "My bucket"
#     Environment = "Dev"
#   }
# }

# resource "aws_s3_bucket_versioning" "main" {
#   bucket = aws_s3_bucket.main.id

#   versioning_configuration {
#     status = "Disabled"
#   }

#   lifecycle {
#     postcondition {
#       condition     = self.versioning_configuration[0].status == "Enabled"
#       error_message = "Versioning must be enabled!"
#     }
#   }
# }
