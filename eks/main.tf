provider "aws" {
  region  = var.AWS_REGION
  profile = var.AWS_PROFILE
}

module "vpc" {
  source      = "../modules/vpc"
  cidr_vpc    = var.VPC_CIDR
  app_name    = var.APP_NAME
  cidr_access = var.CIDR_ACCESS
  cidr_subnet1 = var.CIDR_SUBNET1
  cidr_subnet2 = var.CIDR_SUBNET2
  public      = var.PUBLIC
  region      = var.AWS_REGION
}

module "eks_nodegroup" {
  source         = "../modules/eks"

  clusterName    = var.APP_NAME
  instance_types = var.INSTANCE_TYPE
  desiredSize    = var.DESIRED
  maxSize        = var.MAX
  subneta        = module.vpc.subnet_ida
  subnetb        = module.vpc.subnet_idb
}
