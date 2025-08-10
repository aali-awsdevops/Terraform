# Route Table Creation for private subnet

resource "aws_route_table" "exp_public_route_table" {
  vpc_id = aws_vpc.exp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.exp-public-internet-gateway.id
  }
  depends_on = [aws_vpc.exp-vpc, aws_internet_gateway.exp-public-internet-gateway]
  tags = {
    Name = "EXP-PUB"
  }
}


# Route table association public subnet

resource "aws_route_table_association" "exp_route_public_table" {
  subnet_id      = aws_subnet.exp_public_subnet.id
  route_table_id = aws_route_table.exp_public_route_table.id
}


# Route Table Creation for private subnet

resource "aws_route_table" "exp-private-route-table" {
  vpc_id = aws_vpc.exp-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.exp-nat-gw.id
  }
  depends_on = [aws_nat_gateway.exp-nat-gw]
  tags = {
    Name = "EXP-PVT"
  }
}

## Route table association public subnet

resource "aws_route_table_association" "exp-route-table" {
  subnet_id      = aws_subnet.exp_private_subnet.id
  route_table_id = aws_route_table.exp-private-route-table.id
}
