provider "aws" {
  region  = var.AWS_REGION
  profile = var.AWS_PROFILE
}

module "vpc" {
  source      = "../modules/vpc"
  cidr_vpc    = var.VPC_CIDR
  app_name    = var.APP_NAME
  cidr_access = var.CIDR_ACCESS
  cidr_subnet = var.CIDR_SUBNET
  public      = var.PUBLIC
  region      = var.AWS_REGION
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "web" {
  name             = "personal-site"
  max_size         = 4
  min_size         = 2
  desired_capacity = 2

  #availability_zones = [data.aws_availability_zones.all.names]
  #force_delete = true
  vpc_zone_identifier = [module.vpc.subnet_id]

  load_balancers = [aws_elb.asg_lb.name]

  #health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  tag {
    key                 = "created_By"
    value               = "terraform"
    propagate_at_launch = true
  }
  lifecycle {
    ignore_changes = [min_size, max_size, desired_capacity]
  }
}

resource "aws_launch_template" "web" {
  name = "webhost"

  #ebs_optimized = true
  image_id = var.AMI

  iam_instance_profile {
    name = aws_iam_instance_profile.web.name
  }

  instance_type = "t2.micro"
  key_name      = aws_key_pair.asg.id
  user_data     = base64encode(file("../docker/docker.sh"))

  #vpc_security_group_ids = [aws_security_group.ssh-allowed.id]
  network_interfaces {
    subnet_id       = module.vpc.subnet_id
    security_groups = [aws_security_group.ssh-allowed.id]
  }
}

resource "aws_iam_instance_profile" "web" {
  name = "web-ip"
  role = aws_iam_role.web.name
}

resource "aws_key_pair" "asg" {
  key_name   = "asg"
  public_key = "${file("${path.module}/../infrastructure/${var.PUBLIC_KEY_PATH}")}"
}

## Security Group for ELB
resource "aws_security_group" "elb" {
  name   = "terraform-example-elb"
  vpc_id = module.vpc.vpcID

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### Creating ELB
resource "aws_elb" "asg_lb" {
  name            = "terraform-asg-example"
  security_groups = [aws_security_group.elb.id]

  #availability_zones = [data.aws_availability_zones.all.names]
  subnets = [module.vpc.subnet_id]

  #health_check {
  #  healthy_threshold = 2
  #  unhealthy_threshold = 10
  #  timeout = 2
  #  interval = 5
  #  target = "HTTPS:8200/v1/sys/health"
  #}
  #listener {
  #  lb_port = 80
  #  lb_protocol = "http"
  #  instance_port = "8200"
  #  instance_protocol = "https"
  #}
  #health_check {
  #  healthy_threshold = 2
  #  unhealthy_threshold = 10
  #  timeout = 60
  #  interval = 300
  #  target = "HTTP:80/"
  #}
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 2
    interval            = 5
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }
}
