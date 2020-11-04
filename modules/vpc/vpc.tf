resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name       = var.app_name
    Created_by = "terraform"
  }
}

#resource "aws_subnet" "prod-subnet-public-1" {
#  vpc_id                  = "${aws_vpc.main_vpc.id}"
#  cidr_block              = "${var.cidr_subnet}"
#  map_public_ip_on_launch = "true"                   //it makes this a public subnet
#  availability_zone       = "us-east-1a"
#
#  tags {
#    Name       = "prod-subnet-public-1"
#    Created_by = "terraform"
#  }
#}
