# Creates multiple public subnets across different AZs
resource "aws_subnet" "public-subnets" {
  count             = length(distinct(var.public_cidrs))
  vpc_id            = aws_vpc.uat_vpc.id
  cidr_block        = element(distinct(var.public_cidrs), count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.vpc_name}-PublicSubnet-${count.index + 1}"
  }
}

# Creates multiple private subnets across different AZs
resource "aws_subnet" "private-subnets" {
  count             = length(distinct(var.private_cidrs))
  vpc_id            = aws_vpc.uat_vpc.id
  cidr_block        = element(distinct(var.private_cidrs), count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.vpc_name}-PrivateSubnet-${count.index + 1}"
  }
}