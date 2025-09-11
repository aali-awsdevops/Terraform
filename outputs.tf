# These outputs need not be declared in variables and they don't need to match to that of module 
# these are optional. Only if you want to display them on the screen, then you mention as below

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_range" { 
 value = module.vpc.vpc_cidr
}

output "vpc_public_subnets" {
  value = module.vpc.vpc_public_subnets
}

output "vpc_private_subnets" {
  value = module.vpc.vpc_private_subnets
}

#output "rds_postgres_endpoint" {
#
#  value = module.rds-postgres.rds_postgres_endpoint 
#
#}



output "ops360_launch_template" {
  value = aws_launch_template.ops360.id
}

output "alpha_launch_template" {
  value = aws_launch_template.alpha.id
}