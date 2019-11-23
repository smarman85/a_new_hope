resource "aws_security_group" "access" {
  vpc_id = var.VPC_ID

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = var.CIDR_OUTBOUND
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    
    // this means all ips are allowed to ssh 
    // big no-no for prod
    cidr_blocks = var.CIDR_ACCESS
  }
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = var.CIDR_ACCESS
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = var.CIDR_ACCESS
  }

  tags = {
    Name = "${var.APP_NAME}-firewall"
    Created_by = "terraform"
  }
}
