resource "aws_iam_instance_profile" "ssm_ip" {
  name = "ssm_access_role"
  role = "${aws_iam_role.ssm_role.name}"
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
