#resource "aws_route53_zone" "primary" {
#  name = "seanhome.xyz"
#}

#resource "aws_route53_record" "www-dev" {
#  zone_id = "${aws_route53_zone.primary.zone_id}"
#  name    = "drone.seanhome.xyz"
#  type    = "A"
#  ttl     = "5"
#
#  records = ["${aws_instance.drone.public_ip}"]
#}
