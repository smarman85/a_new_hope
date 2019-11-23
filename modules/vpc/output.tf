output "vpcID" {
  value = aws_vpc.main_vpc.id
}

output "subnet_id" {
  value = aws_subnet.subnet_1.id
}

#output "vpc_sec_group_id" {
#  value = aws_security_group.ssh-access.id
#}
