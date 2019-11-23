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

# build / configure ec2

module "ec2" {
  source = "../modules/ec2/"

  AMI_ID = var.ami_ID
  INSTANCE_TYPE = var.instance_type
  SUBNET_ID = module.vpc.subnet_id
  VPC_SECURITY_GROUP = [module.vpc.vpc_sec_group_id]
  EC2_USER = var.ec2_user
  PRIVATE_KEY = file("${path.module}/${var.priv_key}")
  PUBLIC_KEY_PATH = file("${path.module}/${var.pub_key}")
  PROVISIONER_FILE = var.provision_script
}
