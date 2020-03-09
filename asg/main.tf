provider "aws" {
  region = "${var.AWS_REGION}"
  profile = "${var.AWS_PROFILE}"
}

module "vpc" {
  source = "../modules/vpc"
  cidr_vpc    = "${var.VPC_CIDR}"
  app_name    = "${var.APP_NAME}"
  cidr_access = "${var.CIDR_ACCESS}"
  cidr_subnet = "${var.CIDR_SUBNET}"
  public      = "${var.PUBLIC}"
}

resource "aws_autoscaling_group" "web" {
  name = "personal-site"
  max_size = 4
  min_size = 2
  desired_capacity = 2
  force_delete = true
  #vpc_zone_identifier = ["${module.vpc.subnet_id}"]

  launch_template {
    id = "${aws_launch_template.web.id}"
    version = "$$Latest"
  }

  tag {
    key       = "created_By"
    value = "terraform"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = ["min_size", "max_size", "desired_capacity"]
  }
}

resource "aws_launch_template" "web" {
  name = "webhost"
  #ebs_optimized = true
  image_id = "${var.AMI}"
  iam_instance_profile { 
    name = "${aws_iam_instance_profile.web.name}"
  }
  instance_type = "t2.micro"
  #key_name = "../infrastructure/${var.PRIVATE_KEY_PATH}"
  user_data = "${base64encode(file("../docker/docker.sh"))}"
  #vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  network_interfaces {
    subnet_id = "${module.vpc.subnet_id}"
    security_groups = ["${aws_security_group.ssh-allowed.id}"]
  }
}

resource "aws_iam_instance_profile" "web" {
  name = "web-ip"
  role = "${aws_iam_role.web.name}"
}
