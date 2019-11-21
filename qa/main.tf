provider "aws" {
  region  = var.AWS_REGION
  profile = var.AWS_PROFILE
}


# build a vpc:
module "vpc" {
  source = "../modules/vpc/"

  CIDR_VPC = var.cidr_vpc
  CIDR_SUBNET = var.cidr_subnet
  CIDR_ACCESS = var.cidr_access
  APP_NAME   = var.name
  PUBLIC     = var.public
}
