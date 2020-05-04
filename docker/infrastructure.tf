module "vpc" {
  source = "../modules/vpc"

  cidr_vpc    = "${var.VPC_CIDR}"
  app_name    = "${var.APP_NAME}"
  cidr_access = "${var.CIDR_ACCESS}"
  cidr_subnet = "${var.CIDR_SUBNET}"
  public      = "${var.PUBLIC}"
      
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = "${module.vpc.vpcID}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    // This means, all ip address are allowed to ssh !
    // Do not do it in the production.
    // Put your office or home address in it!
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    // This means, all ip address are allowed to ssh !
    // Do not do it in the production.
    // Put your office or home address in it!
    cidr_blocks = ["0.0.0.0/0"]
  }

  //If you do not add this rule, you can not reach the NGINX
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name       = "ssh-allowed"
    Created_by = "terraform"
  }
}

