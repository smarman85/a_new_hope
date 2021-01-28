variable "AWS_REGION" {
  default = "us-west-2"
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

variable "APP_NAME" {
  default = "homelab"
}

variable "AMI" {
  default = "ami-0c1c0191392d93c6a"
}

variable "CIDR_SUBNET" {
  default = "10.0.1.0/24"
}

variable "CIDR_SUBNET1" {
  default = "10.0.1.0/24"
}

variable "CIDR_SUBNET2" {
  default = "10.0.2.0/24"
}

variable "PUBLIC" {
  default = "true"
}

variable "MAX" {
  default = "3"
}

variable "MIN" {
  default = "2"
}

variable "DESIRED" {
  default = "2"
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
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
