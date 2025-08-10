# Output Block
output "availability_zones" {
  value       = data.aws_availability_zones.available.names
  description = "List of available AZs in the current AWS region"
}

# OUTPUT for subtnets id

output "public-subnet-id" {
  value = aws_subnet.exp_public_subnet.id
}

output "private-subnetid" {
  value = aws_subnet.exp_private_subnet.id
}

# IGW

output "igw_id" {
  value = aws_internet_gateway.exp-public-internet-gateway.id
}

#EIP

output "eip_id" {
  value = aws_eip.exp_nat_eip.id
}

# NATGW ID

output "natgw_id" {
  value = aws_nat_gateway.exp-nat-gw.id
}

# Route Table ID

output "route_table_id" {
  value = aws_route_table.exp_public_route_table.id
}