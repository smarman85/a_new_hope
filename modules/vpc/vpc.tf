resource "aws_vpc" "main_vpc" {
  cidr_block           = var.CIDR_VPC
  enable_dns_support   = "true" # gives you internal domain name
  enable_dns_hostnames = "true" # gives you internal host name
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name       = var.APP_NAME
    Created_by = "terraform"
  }
}
