resource "aws_lb" "alb" {
  name               = "${var.appName}"
  internal           = "${var.internal}"
  load_balancer_type = "${var.lbType}"
  security_groups    = ["${var.securityGroups}"]
  subnets            = ["${var.subnetID}"]

  enable_deletion_protection = true

  #access_logs {
  #  bucket  = "${aws_s3_bucket.lb_logs.bucket}"
  #  prefix  = "test-lb"
  #  enabled = true
  #}

  tags = {
    createdBy = "terraform"
  }
}
