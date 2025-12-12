# Primary VPC in us-east-1
resource "aws_vpc" "primary" {
  provider             = aws.primary
  cidr_block           = var.primary_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "Primary-vpc-${var.primary_region}"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Secondary VPC in us-west-2
resource "aws_vpc" "secondary" {
  provider             = aws.secondary
  cidr_block           = var.secondary_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "Secondary-vpc-${var.secondary_region}"
    Project     = var.project_name
    Environment = var.environment
  }
}


# Primary Subnet in primary vpc in us-east-1
resource "aws_subnet" "primary_subnet" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = var.primary_subnet_cidr
  availability_zone       = data.aws_availability_zones.primary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Primary-subnet-${var.primary_region}"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Secondary Subnet in secondary vpc in us-west-2
resource "aws_subnet" "secondary_subnet" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = var.secondary_subnet_cidr
  availability_zone       = data.aws_availability_zones.secondary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Secondary-subnet-${var.secondary_region}"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Internet Gateway for Primary VPC
resource "aws_internet_gateway" "primary_igw" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id

  tags = {
    Name        = "Primary-igw"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Internet Gateway for Secondary VPC
resource "aws_internet_gateway" "secondary_igw" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id

  tags = {
    Name        = "Secondary-igw"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Route Table for Primary VPC
resource "aws_route_table" "primary_rt" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
  }

  tags = {
    Name        = "Primary-rt"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Route Table for Secondary VPC
resource "aws_route_table" "secondary_rt" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary_igw.id
  }

  tags = {
    Name        = "Secondary-rt"
    Project     = var.project_name
    Environment = var.environment
  }
}


# Associate Primary Subnet with Primary Route Table
resource "aws_route_table_association" "primary_rta" {
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_rt.id
}

# Associate Secondary Subnet with Secondary Route Table
resource "aws_route_table_association" "secondary_rta" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.secondary_rt.id
}

# VPC Peering Connection Requester (Primary VPC)
resource "aws_vpc_peering_connection" "primary_to_secondary_peering" {
  provider    = aws.primary
  vpc_id      = aws_vpc.primary.id
  peer_vpc_id = aws_vpc.secondary.id
  peer_region = var.secondary_region
  auto_accept = false

  tags = {
    Name        = "Primary-to-Secondary-peering"
    Project     = var.project_name
    Environment = var.environment
  }
}

# VPC Peering Connection Accepter (Secondary VPC)
resource "aws_vpc_peering_connection_accepter" "vpc_peering_accepter" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary_peering.id
  auto_accept               = true

  tags = {
    Name        = "Secondary-to-Primary-peering"
    Project     = var.project_name
    Environment = var.environment
  }
}


# Update Route Table in Primary VPC to route traffic to Secondary VPC
resource "aws_route" "primary_to_secondary_route" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_rt.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary_peering.id

  depends_on = [aws_vpc_peering_connection_accepter.vpc_peering_accepter]
}

# Update Route Table in Secondary VPC to route traffic to Primary VPC
resource "aws_route" "secondary_to_primary_route" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_rt.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary_peering.id

  depends_on = [aws_vpc_peering_connection_accepter.vpc_peering_accepter]
}


# Security Group for Primary EC2 Instance

resource "aws_security_group" "primary_sg" {
  provider    = aws.primary
  name        = "primary-vpc-sg"
  description = "Security group for primary VPC instance"
  vpc_id      = aws_vpc.primary.id

  # SSH access for management 
  ingress {
    description = "SSH from anywhere (for demo only)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP (ping) from secondary VPC
  ingress {
    description = "ICMP from secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }
    # HTTP access from secondary VPC
    ingress {
    description = "HTTP from primary VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  # All TCP traffic from secondary VPC (for demo - tighten in production)
  ingress {
    description = "All TCP from secondary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Primary_VPC-SG"
    Region      = var.primary_region
    Environment = var.environment
  }
}

# Security Group for Secondary EC2 Instance
resource "aws_security_group" "secondary_sg" {
  provider    = aws.secondary
  name        = "secondary-vpc-sg"
  description = "Security group for secondary VPC instance"
  vpc_id      = aws_vpc.secondary.id

  # SSH access for management 
  ingress {
    description = "SSH from anywhere (for demo only)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP (ping) from primary VPC
  ingress {
    description = "ICMP from primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  # All TCP traffic from primary VPC (for demo - tighten in production)
  ingress {
    description = "All TCP from primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }
    # HTTP access from primary VPC
  ingress {
    description = "HTTP from primary VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Secondary_VPC-SG"
    Region      = var.secondary_region
    Environment = var.environment
  }
}

# EC2 Instance in Primary VPC
resource "aws_instance" "primary_instance" {
  provider               = aws.primary
  ami                    = data.aws_ami.primary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.primary_subnet.id
  vpc_security_group_ids = [aws_security_group.primary_sg.id]
  key_name               = var.primary_key_name

  user_data = local.primary_user_data

  tags = {
    Name        = "Primary-EC2-Instance"
    Region      = var.primary_region
    Environment = var.environment
  }

  depends_on = [aws_vpc_peering_connection_accepter.vpc_peering_accepter]
}

# EC2 Instance in Secondary VPC
resource "aws_instance" "secondary_instance" {
  provider               = aws.secondary
  ami                    = data.aws_ami.secondary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.secondary_subnet.id
  vpc_security_group_ids = [aws_security_group.secondary_sg.id]
  key_name               = var.secondary_key_name

  user_data = local.secondary_user_data

  tags = {
    Name        = "Secondary-EC2-Instance"
    Region      = var.secondary_region
    Environment = var.environment
  }

  depends_on = [aws_vpc_peering_connection_accepter.vpc_peering_accepter]
}
