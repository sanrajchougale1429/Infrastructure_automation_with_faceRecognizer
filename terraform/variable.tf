variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "12.0.0.0/22"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  default     = "12.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  default     = "12.0.2.0/24"
}


