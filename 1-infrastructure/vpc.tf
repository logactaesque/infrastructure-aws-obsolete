provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "logactaesque-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Logactaesque VPC"
  }
}

resource "aws_subnet" "public-subnet-1" {
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.logactaesque-vpc.id
  availability_zone = "eu-west-1a"
}

resource "aws_subnet" "public-subnet-2" {
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.logactaesque-vpc.id
  availability_zone = "eu-west-1b"
}

resource "aws_subnet" "private-subnet-1" {
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.logactaesque-vpc.id
  availability_zone = "eu-west-1a"
}

resource "aws_subnet" "private-subnet-2" {
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.logactaesque-vpc.id
  availability_zone = "eu-west-1b"
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.logactaesque-vpc.id

  tags = {
    Name = "Logactaesque Development Public Route Table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.logactaesque-vpc.id

  tags = {
    Name = "Logactaesque Development Private Route Table"
  }
}

resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}

resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2.id
}


# Use a NAT gateway to enable instances in a private subnet to connect to the internet or other AWS services,
# but prevent the internet from initiating a connection with those instances.
resource aws_eip "logactaesque-nat-gw-eip" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
    Name = "Logactaesque Development NAT GW EIP"
  }

  depends_on = [aws_internet_gateway.logactaesque-igw]
}

resource aws_nat_gateway "logactaesque-nat-gw" {
  allocation_id = aws_eip.logactaesque-nat-gw-eip.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "Logactaesque Development NAT GW"
  }
  depends_on = [aws_eip.logactaesque-nat-gw-eip]

}

resource "aws_route" "logactaesque-nat-gw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.logactaesque-nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

# AWS internet gateway allows communication between VPC and internet
resource "aws_internet_gateway" "logactaesque-igw" {
  vpc_id = aws_vpc.logactaesque-vpc.id

  tags = {
    Name = "Logactaesque Development IGW"
  }
}

resource "aws_route" "logactaesque-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.logactaesque-igw.id
  destination_cidr_block = "0.0.0.0/0"
}


