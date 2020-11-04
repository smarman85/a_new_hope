#data "aws_availability_zones" "available" {
#  state = "available"
#}
#
#resource "aws_subnet" "eks" {
#  count = 2
#
#  availability_zone = data.aws_availability_zones.available.names[count.index]
#  cidr_block        = cidrsubnet(aws_vpc.eks.cidr_block, 8, count.index)
#  vpc_id            = aws_vpc.eks.id
#
#  tags = {
#    "kubernetes.io/cluster/${aws_eks_cluster.eks.name}" = "shared"
#  }
#}
