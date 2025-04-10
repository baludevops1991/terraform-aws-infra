# Creates the uat VPC with specified CIDR block and DNS hostnames enabled for internal name resolution.
resource "aws_vpc" "uat_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.vpc_name}"
    environment = "${var.environment}"
  }
}

# Attaches an Internet Gateway to the VPC to enable internet access for public subnets.
resource "aws_internet_gateway" "uat_IGW" {
  vpc_id = aws_vpc.uat_vpc.id
  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}