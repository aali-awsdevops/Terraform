locals {
  az = data.aws_availability_zones.available.names[0]
}

# Public Sub-Net

resource "aws_subnet" "exp_public_subnet" {
  vpc_id                  = aws_vpc.exp-vpc.id
  cidr_block              = var.vpc_cidr_block[1]
  availability_zone       = local.az
  map_public_ip_on_launch = true
  tags = {
    Name = "Exoduspoint-Public-subnet"
  }
  depends_on = [aws_vpc.exp-vpc]

}

# private subnet

resource "aws_subnet" "exp_private_subnet" {
  vpc_id            = aws_vpc.exp-vpc.id
  cidr_block        = var.vpc_cidr_block[2]
  availability_zone = local.az
  tags = {
    Name = "Exoduspoint-Private-subnet"
  }

  depends_on = [aws_vpc.exp-vpc]

}