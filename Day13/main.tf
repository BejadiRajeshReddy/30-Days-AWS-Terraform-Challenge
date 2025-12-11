# Data source: Fetch existing VPC
data "aws_vpc" "shared" {
  filter {
    name   = "tag:Name"
    values = ["day13"]
  }
}

# Data source: Fetch existing subnet
data "aws_subnet" "shared" {
  filter {
    name   = "tag:Name"
    values = ["day13-subnet"]
  }

  vpc_id = data.aws_vpc.shared.id   # Ensure subnet is within the fetched VPC
}

# Data source: Fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]   # Match Amazon Linux 2 AMI pattern
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Resource: EC2 instance using data sources
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnet.shared.id

  tags = {
    Name = "day-13-instance"
  }
}
