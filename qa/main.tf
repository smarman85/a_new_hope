provider "aws" {
  region  = var.AWS_REGION
  profile = var.AWS_PROFILE
}


# build a vpc:
module "vpc" {
  source = "../modules/vpc/"

  CIDR_VPC = var.cidr_vpc
  CIDR_SUBNET = var.cidr_subnet
  CIDR_ACCESS = var.cidr_ingress
  APP_NAME   = var.name
  PUBLIC     = var.public
}

# add security group
module "security_groups" {
  source = "../modules/security_groups/"
  
  VPC_ID = module.vpc.vpcID
  CIDR_OUTBOUND = var.firewall_egress
  CIDR_ACCESS = var.firewall_ingress
  APP_NAME = var.name
}

# build / configure ec2
module "ec2" {
  source = "../modules/ec2/"

  AMI_ID = var.ami_ID
  INSTANCE_TYPE = var.instance_type
  SUBNET_ID = module.vpc.subnet_id
  VPC_SECURITY_GROUP = [module.security_groups.sec_group_id]
  EC2_USER = var.ec2_user
  PRIVATE_KEY = file("${path.module}/${var.priv_key}")
  PUBLIC_KEY_PATH = file("${path.module}/${var.pub_key}")
  PROVISIONER_FILE = var.provision_script
}
