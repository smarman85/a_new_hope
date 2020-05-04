provider "aws" {
  region = "${var.AWS_REGION}"
  profile = "${var.AWS_PROFILE}"
}

resource "aws_iam_instance_profile" "ssm_ip" {
  name = "ssm_access_role"
  role = "${aws_iam_role.ssm_role.name}"
}

resource "aws_instance" "drone" {
  ami           = "${var.AMI}"
  instance_type = "t2.micro"

  #role for ssm
  iam_instance_profile = "${aws_iam_instance_profile.ssm_ip.name}"

  #VPC info
  #subnet_id = "${var.SUBNET_ID}"
  subnet_id = "${module.vpc.subnet_id}"

  # Security Group
  #vpc_security_group_ids = ["${var.VPC_SECURITY_GROUP}"]
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]

  # drone installation
  user_data      = "${file("${path.module}/../configs/drone.sh")}"
}

resource "aws_iam_role" "ssm_role" {
  name = "ssm-access"
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

resource "aws_iam_role_policy_attachment" "ssm-policy" {
  role       = "${aws_iam_role.ssm_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

