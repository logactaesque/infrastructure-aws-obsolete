variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
}

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
}

variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
}

variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
}

variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
}
