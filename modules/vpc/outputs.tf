output "vpcID" {
  value = aws_vpc.main_vpc.id
}

#output "subnet_id" {
#  value = aws_subnet.subnet.id
#}

output "subnet_ida" {
  value = aws_subnet.subnet_1.id
}

output "subnet_idb" {
  value = aws_subnet.subnet_2.id
}
