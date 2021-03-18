output "vpc_id" {
  value = aws_vpc.logactaesque-dev-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.logactaesque-dev-vpc.cidr_block
}

output "public-subnet-id" {
  value = aws_subnet.public-subnet.id
}

output "private-subnet-id" {
  value = aws_subnet.private-subnet.id
}