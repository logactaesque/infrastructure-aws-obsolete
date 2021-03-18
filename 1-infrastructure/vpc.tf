provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "logactaesque-dev-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Logactaesque Development VPC"
  }
}

# Would most likely create multiple public/private subnets across different AZ's for our region
resource "aws_subnet" "public-subnet" {
  cidr_block        = var.public_subnet_cidr
  vpc_id            = aws_vpc.logactaesque-dev-vpc.id
  availability_zone = "eu-west-1a"
}

resource "aws_subnet" "private-subnet" {
  cidr_block        = var.private_subnet_cidr
  vpc_id            = aws_vpc.logactaesque-dev-vpc.id
  availability_zone = "eu-west-1a"
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.logactaesque-dev-vpc.id

  tags = {
    Name = "Logactaesque Development Public Route Table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.logactaesque-dev-vpc.id

  tags = {
    Name = "Logactaesque Development Private Route Table"
  }
}

resource "aws_route_table_association" "public-subnet-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet.id
}

resource "aws_route_table_association" "private-subnet-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet.id
}

# Use a NAT gateway to enable instances in a private subnet to connect to the internet or other AWS services,
# but prevent the internet from initiating a connection with those instances.
resource aws_eip "elastic-ip-for-logactaesque-dev-nat-gw" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
    Name = "Logactaesque Development EIP"
  }
}

resource aws_nat_gateway "logactaesque-dev-nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-logactaesque-dev-nat-gw.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "Logactaesque Development NAT GW"
  }

  depends_on = [aws_eip.elastic-ip-for-logactaesque-dev-nat-gw]
}

resource "aws_route" "logactaesque-dev-nat-gw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.logactaesque-dev-nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

# AWS internet gateway allows communication between VPC and internet
resource "aws_internet_gateway" "logactaesque-dev-igw" {
  vpc_id = aws_vpc.logactaesque-dev-vpc.id

  tags = {
    Name = "Logactaesque Development IGW"
  }
}

resource "aws_route" "logactaesque-dev-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.logactaesque-dev-igw.id
  destination_cidr_block = "0.0.0.0/0"
}


