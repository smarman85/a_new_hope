# create an IGW (Internet Gateway)
# It enables your vpc to connect to the internet
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  tags {
    Name       = "prod-igw"
    Created_by = "terraform"
  }
}

# create a custom route table for public subnets
# public subnets can reach the internet with this
resource "aws_route_table" "prod-public-crt" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"

    //CRT uses this IGW to reach internet
    gateway_id = "${aws_internet_gateway.prod-igw.id}"
  }

  tags {
    Name       = "prod-public-crt"
    Created_by = "terraform"
  }
}

resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  subnet_id      = "${aws_subnet.prod-subnet-public-1.id}"
  route_table_id = "${aws_route_table.prod-public-crt.id}"
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

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

  //If you do not add this rule, you can not reach the NGIX  
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
