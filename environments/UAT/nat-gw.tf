# Creates an Elastic IP (EIP)
resource "aws_eip" "nat_eip" {

  tags = {
    Name = "NAT-EIP"
  }
}

# Creates a NAT Gateway in the public subnet using the allocated EIP
# and associates it with the internet gateway for internet access.
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-subnets[0].id

  tags = {
    Name = "${var.vpc_name}-nat-gw"
  }
  depends_on = [aws_internet_gateway.uat_IGW]
}
