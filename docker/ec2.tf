provider "aws" {
  region  = "${var.AWS_REGION}"
  profile = "${var.AWS_PROFILE}"
}

resource "aws_iam_instance_profile" "ssm_ip" {
  name = "ssm_access_role"
  role = "${aws_iam_role.ssm_role.name}"
}

resource "aws_instance" "docker1" {
  ami           = "${var.AMI}"
  instance_type = "t2.micro"

  #role for ssm
  iam_instance_profile = "${aws_iam_instance_profile.ssm_ip.name}"

  #VPC info
  subnet_id = "${var.SUBNET_ID}"

  # Security Group
  vpc_security_group_ids = ["${var.VPC_SECURITY_GROUP}"]

  # the public ssh key
  key_name = "${aws_key_pair.key-pair.id}"

  # docker installation
  provisioner "file" {
    source      = "docker.sh"
    destination = "/tmp/docker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/docker.sh",
      "sudo /tmp/docker.sh",
    ]
  }

  connection {
    user        = "${var.EC2_USER}"
    private_key = "${file("${path.module}/../infrastructure/${var.PRIVATE_KEY_PATH}")}"
  }
}

// send public key to instance
resource "aws_key_pair" "key-pair" {
  key_name   = "key-pair"
  public_key = "${file("${path.module}/../infrastructure/${var.PUBLIC_KEY_PATH}")}"
}
