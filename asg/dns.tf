resource "aws_route53_zone" "primary" {
  name = "seanhome.xyz"
}

resource "aws_route53_record" "www-dev" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "5"

  records = ["seanhome.xyz"]
}
