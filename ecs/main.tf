provider "aws" {
  region  = var.AWS_REGION
  profile = var.AWS_PROFILE
}

module "vpc" {
  source      = "../modules/vpc"
  cidr_vpc    = var.VPC_CIDR
  app_name    = var.APP_NAME
  cidr_access = var.CIDR_ACCESS
  cidr_subnet1 = var.CIDR_SUBNET1
  cidr_subnet2 = var.CIDR_SUBNET2
  public      = var.PUBLIC
  region      = var.AWS_REGION
}

resource "aws_key_pair" "asg" {
  key_name   = "asg"
  public_key = "${file("${path.module}/../infrastructure/${var.PUBLIC_KEY_PATH}")}"
}

resource "aws_ecs_task_definition" "gosite" {

    container_definitions    = jsonencode(
        [
            {
                command      = [
                    "/bin/sh -c \"echo '<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground\"",
                ]
                cpu          = 10
                entryPoint   = [
                    "sh",
                    "-c",
                ]
                environment  = []
                essential    = true
                image        = "httpd:2.4"
                memory       = 300
                mountPoints  = []
                name         = "simple-app"
                portMappings = [
                    {
                        containerPort = 80
                        hostPort      = 80
                        protocol      = "tcp"
                    },
                ]
                volumesFrom  = []
            },
        ]
    )
    family                   = "console-sample-app-static"
    requires_compatibilities = []
    tags                     = {
        "created" = "by-hand"
    }

}

resource "aws_ecs_service" "gosite" {
    cluster = aws_ecs_cluster.gosite.id
    deployment_maximum_percent         = 200
    deployment_minimum_healthy_percent = 100
    desired_count                      = 1
    enable_ecs_managed_tags            = true
    health_check_grace_period_seconds  = 0
    iam_role                           = "aws_iam_role.web.name"
    launch_type                        = "EC2"
    name                               = "test-svc-name"
    scheduling_strategy                = "REPLICA"
    tags                               = {}
    task_definition = aws_ecs_task_definition.gosite.arn

    deployment_controller {
        type = "ECS"
    }

    load_balancer {
        container_name   = "simple-app"
        container_port   = 80
        target_group_arn = "arn:aws:elasticloadbalancing:us-west-2:703150260896:targetgroup/ecs-gosite-test-svc-name/198db17eec56de49"
    }

    ordered_placement_strategy {
        field = "attribute:ecs.availability-zone"
        type  = "spread"
    }
    ordered_placement_strategy {
        field = "instanceId"
        type  = "spread"
    }

    timeouts {}

}



resource "aws_ecs_cluster" "gosite" {
    capacity_providers = []
    name               = "gosite2"
    tags               = {}

    setting {
        name  = "containerInsights"
        value = "disabled"
    }

}

resource "aws_launch_configuration" "web" {
    associate_public_ip_address      = false
    ebs_optimized                    = false
    enable_monitoring                = true
    iam_instance_profile             = "arn:aws:iam::703150260896:instance-profile/ecsInstanceRole"
    image_id                         = "ami-0c1c0191392d93c6a"
    instance_type                    = "t2.micro"
    key_name                         = "asg"
    name                             = "EC2ContainerService-gosite2-EcsInstanceLc-12Z3TFW6KO9X3"
    security_groups                  = [aws_security_group.lb_sg.id]
    user_data                        = "2fd2c4729094760b8348903bff90d20bb29d14ad"
    vpc_classic_link_security_groups = []

    root_block_device {
        delete_on_termination = false
        encrypted             = false
        iops                  = 0
        volume_size           = 30
        volume_type           = "gp2"
    }
}

resource "aws_autoscaling_group" "web" {
    availability_zones        = [
        "us-west-2a",
        "us-west-2b",
    ]
    capacity_rebalance        = false
    default_cooldown          = 300
    desired_capacity          = 1
    enabled_metrics           = []
    health_check_grace_period = 0
    health_check_type         = "EC2"
    launch_configuration      = aws_launch_configuration.web.name
    load_balancers            = []
    max_instance_lifetime     = 0
    max_size                  = 1
    metrics_granularity       = "1Minute"
    min_size                  = 0
    name                      = "EC2ContainerService-gosite2-EcsInstanceAsg-YHJPXHRPKHZZ"
    protect_from_scale_in     = false
    service_linked_role_arn   = "arn:aws:iam::703150260896:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
    suspended_processes       = []
    target_group_arns         = []
    termination_policies      = []
    #vpc_zone_identifier       = [
    #    "subnet-0341aaef5e1f5624f",
    #    "subnet-0813b62b29edeb4fe",
    #]

    tag {
        key                 = "Description"
        propagate_at_launch = true
        value               = "This instance is the part of the Auto Scaling group which was created through ECS Console"
    }
    tag {
        key                 = "Name"
        propagate_at_launch = true
        value               = "ECS Instance - EC2ContainerService-gosite2"
    }

    timeouts {}
}

resource "aws_lb" "gosite" {
  name = "gosite-lb-tf"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb_sg.id]
  subnets = [module.vpc.subnet_ida, module.vpc.subnet_idb]
}

resource "aws_security_group" "lb_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpcID

  ingress {
    description = "all in"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_lb_target_group" "gosite" {
  name     = "gosite-lb"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpcID
  target_type = "ip"
  depends_on = [aws_lb.gosite]
}

resource "aws_lb_listener" "gosite" {
  load_balancer_arn = aws_lb.gosite.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.gosite.arn
  }
}

resource "aws_iam_role" "web" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "ec2.amazonaws.com"
                    }
                    Sid       = ""
                },
            ]
            Version   = "2008-10-17"
        }
    )
    force_detach_policies = false
    max_session_duration  = 3600
    name                  = "ecsInstanceRole"
    path                  = "/"
    tags                  = {}
}


resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}






#data "aws_availability_zones" "all" {}
#
#resource "aws_autoscaling_group" "web" {
#  name             = "personal-site"
#  max_size         = 4
#  min_size         = 2
#  desired_capacity = 2
#
#  #availability_zones = [data.aws_availability_zones.all.names]
#  #force_delete = true
#  vpc_zone_identifier = [module.vpc.subnet_ida, module.vpc.subnet_idb]
#
#  load_balancers = [aws_lb.gosite.arn]
#
#  #health_check_type = "ELB"
#
#  launch_template {
#    id      = aws_launch_template.web.id
#    version = "$Latest"
#  }
#  tag {
#    key                 = "created_By"
#    value               = "terraform"
#    propagate_at_launch = true
#  }
#  lifecycle {
#    ignore_changes = [min_size, max_size, desired_capacity]
#  }
#}
#
#resource "aws_launch_template" "web" {
#  name_prefix = "ecs-gosite"
#
#  #ebs_optimized = true
#  image_id = var.AMI
#
#  iam_instance_profile {
#    name = aws_iam_instance_profile.web.name
#  }
#
#  instance_type = "t2.micro"
#  key_name      = aws_key_pair.asg.id
#  #user_data     = base64encode(file("../docker/docker.sh"))
#
#  #vpc_security_group_ids = [aws_security_group.ssh-allowed.id]
#  network_interfaces {
#    subnet_id       = module.vpc.subnet_ida
#    security_groups = [aws_security_group.lb_sg.id]
#  }
#}
#
#resource "aws_iam_instance_profile" "web" {
#  name = "web-ip"
#  role = aws_iam_role.web.name
#}
#resource "aws_iam_role" "web" {
#  name = "web"
#  path = "/"
#
#  assume_role_policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Principal": {
#                "Service": "ec2.amazonaws.com"
#            },
#            "Action": "sts:AssumeRole"
#        }
#    ]
#}
#    EOF
#}
#
#resource "aws_iam_role_policy_attachment" "web" {
#  role       = aws_iam_role.web.name
#  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#}
#
#resource "aws_iam_role_policy_attachment" "ecs" {
#  role       = aws_iam_role.web.name
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
#}
