# create an Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = ${VPC_OUTPUT}

  tags {
    Name       = "${var.APP_NAME}-igw"
    Created_by = "terraform"
  }
}

# create a custom route table for public subnets

resource "aws_subnet" "subnet_1" {
  vpc_id                  = "${}"
  cidr_block              = "${var.CIDR_BLOCK}/24"
  map_public_ip_on_launch = "${var.PUBLIC}" # this makes it public or private
  availability_zone       = "us-east-1a"

  tags {
    Name       = "${var.APP_NAME}-subnet-1"
    Created_by = "terraform"
  }
}
