terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.43.0"
    }
  }
}

provider "aws" {
  region  = var.AWS_REGION
  profile = var.AWS_PROFILE
  default_tags {
    tags = {
      "created_by"  = "terraform"
      "environment" = "homelab"
      "use"         = "docker"
    }
  }
}

resource "aws_autoscaling_group" "demo" {
  name_prefix        = "demo-"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1

  #load_balancers = [aws_lb.demo.name]
  launch_template {
    id      = aws_launch_template.demo.id
    version = "1"
  }

  lifecycle {
    ignore_changes = [min_size, max_size, desired_capacity]
  }
}

resource "aws_launch_template" "demo" {
  name_prefix   = "demo-"
  image_id      = var.AMI
  instance_type = var.INSTANCE_TYPE

  iam_instance_profile {
    name = aws_iam_instance_profile.demo.name
  }

  key_name  = aws_key_pair.demo.key_name
  user_data = base64encode(file("${path.module}/docker.sh"))
}

resource "aws_iam_instance_profile" "demo" {
  name = "demo-ip"
  role = aws_iam_role.demo.name
}

resource "aws_key_pair" "demo" {
  key_name   = "demo"
  public_key = file("${path.module}/../keys/${var.PUBLIC_KEY_PATH}")
}

resource "aws_security_group" "demo" {
  name = "demo-sg"

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
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "demo" {
  name               = "demo-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demo.id]
  subnets            = ["subnet-1d1d7c36", "subnet-2a213e53", "subnet-e3427aa8", "subnet-45739d18"]
}

resource "aws_lb_target_group" "demo" {
  name     = "demo-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.VPCID

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_target_group_attachment" "demo" {
  target_group_arn = aws_lb_target_group.demo.arn
  target_id        = aws_autoscaling_group.demo.id
  port             = 80
}

resource "aws_lb_listener" "demo" {
  load_balancer_arn = aws_lb.demo.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo.arn
  }
}