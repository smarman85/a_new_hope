output "lb_DNS" {
  value = aws_elb.asg_lb.dns_name
}
