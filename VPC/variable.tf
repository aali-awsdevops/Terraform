variable "vpc_cidr_block" {
  type    = list(string)
  default = ["10.0.0.0/16", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}