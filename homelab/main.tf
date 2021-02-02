provider "aws" {
  region  = var.AWS_REGION
  profile = var.APP
}

module "vpc" {
  source      = "../modules/vpc"
  cidr_vpc    = var.VPC_CIDR
  app_name    = var.APP
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

  vpc_zone_identifier = [module.vpc.subnet_id]

  load_balancers = [aws_elb.asg_lb.name]

  launch_configuration = aws_launch_configuration.config.name

  tag {
    key                 = "created_By"
    value               = "terraform"
    propagate_at_launch = true
  }

  tag {
    key                 = "app"
    value               = var.APP
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [min_size, max_size, desired_capacity]
  }

}

resource "aws_iam_instance_profile" "web" {
  name = "web-ip"
  role = aws_iam_role.web.name
}

resource "aws_key_pair" "key" {
  key_name   = "key"
  public_key = "${file("${path.module}/../infrastructure/${var.PUBLIC_KEY_PATH}")}"
}

## Security Group for ELB
resource "aws_security_group" "sg" {
  name   = "homelab-sg"
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

resource "aws_security_group" "ssh-allowed" {
  vpc_id = module.vpc.vpcID

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    // This means, all ip address are allowed to ssh !
    // Do not do it in the production.
    // Put your office or home address in it!
    cidr_blocks = ["0.0.0.0/0"]
  }

  //If you do not add this rule, you can not reach the NGINX
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "ssh-allowed"
    Created_by = "terraform"
  }
}


resource "aws_launch_configuration" "config" {
  name_prefix   = "homelab-"
  instance_type = var.INSTANCE_TYPE
  image_id      = var.AMI
  user_data     = base64encode(file("../docker/docker.sh"))
  key_name      = aws_key_pair.key.id

  iam_instance_profile = aws_iam_instance_profile.web.name

  root_block_device {
    volume_type           = var.VOLUME_TYPE
    volume_size           = var.VOLUME_SIZE
    delete_on_termination = var.VOLUME_DELETE
  }

  security_groups = [aws_security_group.ssh-allowed.id]
}

resource "aws_iam_role" "web" {
  name = "web"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
    EOF
}

resource "aws_iam_role_policy_attachment" "web" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#resource "aws_lb" "web" {
#  name = "alb-homelab"
#  internal = false
#  load_balancer_type = "application"
#  security_groups = [aws_security_group.sg.id]
#  subnets = [module.vpc.subnet_id, aws_subnet.extra.id]
#}

resource "aws_elb" "asg_lb" {
  name            = "terraform-asg-example"
  security_groups = [aws_security_group.sg.id]

  subnets = [module.vpc.subnet_id]

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
