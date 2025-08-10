# INTERNET-GATEWAY CREATION

resource "aws_internet_gateway" "exp-public-internet-gateway" {
  vpc_id = aws_vpc.exp-vpc.id
  tags = {
    Name = "Exoduspoint-IGW"
  }

  depends_on = [aws_vpc.exp-vpc]
}

# EIP allocation

resource "aws_eip" "exp_nat_eip" {
  tags = {
    Name = "EXP-PublicIp"
  }
}

#NAT Gate Way Creation

resource "aws_nat_gateway" "exp-nat-gw" {
  allocation_id = aws_eip.exp_nat_eip.id
  subnet_id     = aws_subnet.exp_public_subnet.id

  tags = {
    Name = "EXp-NAT"
  }


  depends_on = [aws_subnet.exp_private_subnet, aws_eip.exp_nat_eip]
}
