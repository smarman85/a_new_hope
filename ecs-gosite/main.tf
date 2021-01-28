provider "aws" {
  region = "us-west-2"
  profile = "homelab"
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
    cluster                            = "arn:aws:ecs:us-west-2:703150260896:cluster/gosite2"
    deployment_maximum_percent         = 200
    deployment_minimum_healthy_percent = 100
    desired_count                      = 1
    enable_ecs_managed_tags            = true
    health_check_grace_period_seconds  = 0
    iam_role                           = "aws-service-role"
    launch_type                        = "EC2"
    name                               = "test-svc-name"
    scheduling_strategy                = "REPLICA"
    tags                               = {}
    task_definition                    = "console-sample-app-static:1"

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
    security_groups                  = [
        "sg-05c7ae619c1f5a657",
    ]
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
    launch_configuration      = "EC2ContainerService-gosite2-EcsInstanceLc-12Z3TFW6KO9X3"
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
