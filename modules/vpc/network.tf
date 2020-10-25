# create an Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name       = "${var.app_name}-igw"
    Created_by = "terraform"
  }
}

# create a custom route table for public subnets
resource "aws_route_table" "public-crt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    // associated subnet can reach everwhere
    cidr_block = var.cidr_access

    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name       = var.app_name
    Created_by = "terraform"
  }
}

resource "aws_route_table_association" "crta-subnet-1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public-crt.id
}

resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.cidr_subnet
  map_public_ip_on_launch = var.public # this makes it public or private
  availability_zone       = "${var.region}a"

  tags = {
    Name       = "${var.app_name}-subnet-1"
    Created_by = "terraform"
  }
}
