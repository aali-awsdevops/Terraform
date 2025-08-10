# Exoduspoint Client VPC

resource "aws_vpc" "exp-vpc" {
  cidr_block           = var.vpc_cidr_block[0]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Exodupoint-VPC"
  }
}
