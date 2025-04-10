# Creates a route table for the public subnet with a route to the internet via the Internet Gateway.
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.uat_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.uat_IGW.id
  }

  tags = {
    Name = "${var.vpc_name}-PublicRT"
  }
}

# Creates a route table for private subnets with a route to the internet via the NAT Gateway.
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.uat_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.vpc_name}-PrivateRT"
  }
}

# Associates the public route table with each public subnet based on the CIDR blocks defined in the variable.
resource "aws_route_table_association" "public-subnets" {
  count          = length(distinct(var.public_cidrs))
  subnet_id      = element(aws_subnet.public-subnets.*.id, count.index)
  route_table_id = aws_route_table.public-rt.id
}

# Associates the private route table with each private subnet based on the CIDR blocks defined in the variable.
resource "aws_route_table_association" "private-subnets" {
  count          = length(distinct(var.private_cidrs))
  subnet_id      = element(aws_subnet.private-subnets.*.id, count.index)
  route_table_id = aws_route_table.private-rt.id
}