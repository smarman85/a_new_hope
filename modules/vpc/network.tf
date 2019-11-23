# create an Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name       = "${var.APP_NAME}-igw"
    Created_by = "terraform"
  }
}

# create a custom route table for public subnets
resource "aws_route_table" "public-crt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    // associated subnet can reach everwhere
    cidr_block = var.CIDR_ACCESS

    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name       = var.APP_NAME
    Created_by = "terraform"
  }
}

resource "aws_route_table_association" "crta-subnet-1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public-crt.id
}

resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.CIDR_SUBNET
  map_public_ip_on_launch = var.PUBLIC # this makes it public or private
  availability_zone       = "us-east-1a"

  tags = {
    Name       = "${var.APP_NAME}-subnet-1"
    Created_by = "terraform"
  }
}

resource "aws_security_group" "ssh-access" {
  vpc_id = aws_vpc.main_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${var.CIDR_ACCESS}"]
  }
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

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

  tags = {
    Name       = "${var.APP_NAME}-ssh-allowed"
    Created_by = "terraform"
  }
}
