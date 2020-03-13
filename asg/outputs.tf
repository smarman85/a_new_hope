output "lb_DNS" {
  value = "${aws_elb.asg-lb.dns_name}"
}
