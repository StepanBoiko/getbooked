provider "aws" {
  region = "us-east-1"
  access_key = "AKIAVJSSS3HW75LM54WY"
  secret_key = "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"
}



# Create a VPC
resource "aws_vpc" "bookedApp-vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "bookedApp-vpc"
  }
}

# Create a subnets within the VPC
resource "aws_subnet" "bookedApp-vpc-public-subnet-1" {
  vpc_id                  = aws_vpc.bookedApp-vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "us-east-1a"

  map_public_ip_on_launch = true
  assign_ipv6_address_on_creation = false

  tags = {
    Name = "bookedApp-vpc-public-subnet-1"
  }
}

resource "aws_subnet" "bookedApp-vpc-public-subnet-2" {
  vpc_id                        = aws_vpc.bookedApp-vpc.id
  cidr_block                    = "10.10.2.0/24"
  availability_zone             = "us-east-1b"

  map_public_ip_on_launch = true
  assign_ipv6_address_on_creation = false

  tags = {
    Name = "bookedApp-vpc-public-subnet-2"
  }
}


resource "aws_subnet" "bookedApp-vpc-private-subnet-1" {
  vpc_id                  = aws_vpc.bookedApp-vpc.id
  cidr_block              = "10.10.6.0/24"
  availability_zone       = "us-east-1a"

  map_public_ip_on_launch = false

  tags = {
    Name = "bookedApp-vpc-private-subnet-1"
  }
}

resource "aws_subnet" "bookedApp-vpc-private-subnet-2" {
  vpc_id                          = aws_vpc.bookedApp-vpc.id
  cidr_block                      = "10.10.7.0/24"
  availability_zone               = "us-east-1b"

  map_public_ip_on_launch = false

  tags = {
    Name = "bookedApp-vpc-private-subnet-2"
  }
}


# Create internet gateway
resource "aws_internet_gateway" "bookedAppIGW" {
  vpc_id = aws_vpc.bookedApp-vpc.id

  tags = {
    Name = "bookedAppIGW"
  }
}

# Create route table
resource "aws_route_table" "bookedAppRouteTable" {
  vpc_id = aws_vpc.bookedApp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bookedAppIGW.id
  }

  tags = {
    Name = "bookedAppRouteTable" 
  }
}

#Associate subnet with route table 

resource "aws_route_table_association" "association-public1-subnet-bookedApp" {
  subnet_id      = aws_subnet.bookedApp-vpc-public-subnet-1.id
  route_table_id = aws_route_table.bookedAppRouteTable.id
}

resource "aws_route_table_association" "association-public2-subnet-bookedApp" {
  subnet_id      = aws_subnet.bookedApp-vpc-public-subnet-2.id
  route_table_id = aws_route_table.bookedAppRouteTable.id
}

resource "aws_route_table_association" "association-private1-subnet-bookedApp" {
  subnet_id      = aws_subnet.bookedApp-vpc-private-subnet-1.id
  route_table_id = aws_route_table.bookedAppRouteTable.id
}

resource "aws_route_table_association" "association-private2-subnet-bookedApp" {
  subnet_id      = aws_subnet.bookedApp-vpc-private-subnet-2.id
  route_table_id = aws_route_table.bookedAppRouteTable.id
}


# Create a security group for the EC2 instance
resource "aws_security_group" "bookedAppSecurityGroup" {
  name        = "bookedAppSecurityGroup"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.bookedApp-vpc.id

  ingress {
    from_port   = 3003
    to_port     = 3003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "tls_private" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "bookedAppInstanceKey"
  public_key = tls_private_key.tls_private.public_key_openssh
}

output "private_key_pem" {
  value     = tls_private_key.tls_private.private_key_pem
  sensitive = true
}


# Create an EC2 instance
resource "aws_instance" "bookedAppInstance" {
  ami           = "ami-079db87dc4c10ac91"  # Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name  # Set your key pair name
  subnet_id     = aws_subnet.bookedApp-vpc-public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.bookedAppSecurityGroup.id]

  root_block_device {
    volume_size = 8  # Size of the root EBS volume in GB
  }

  tags = {
    Name = "bookedAppInstance"
  }
}