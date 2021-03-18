variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
}

variable "private_subnet_cidr" {
  description = "Private Subnet CIDR"
}
