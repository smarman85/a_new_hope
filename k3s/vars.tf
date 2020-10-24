variable "AWS_REGION" {
  default = "us-west-1"
}

variable "AWS_PROFILE" {
  default = "homelab"
}

variable "VPC_CIDR" {
  default = "10.0.0.0/16"
}

variable "CIDR_ACCESS" {
  default = "0.0.0.0/0"
}

variable "CIDR_SUBNET" {
  default = "10.0.1.0/24"
}

variable "PUBLIC" {
  default = "true"
}

variable "APP_NAME" {
  default = "docker-asg"
}

variable "PRIVATE_KEY_PATH" {
  default = "ec2-key-pair"
}

variable "PUBLIC_KEY_PATH" {
  default = "ec2-key-pair.pub"
}

variable "EC2_USER" {
  default = "ubuntu"
}

variable "AMI" {
  default = "ami-07ebfd5b3428b6f4d"
}
