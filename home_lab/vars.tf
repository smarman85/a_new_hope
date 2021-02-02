variable "AWS_REGION" {
  #default = "us-east-1"
  default = "us-west-1"
  #default = "us-west-2"
}

variable "AMI" {
  #default = "ami-07ebfd5b3428b6f4d"  # us-east-1
  default = "ami-021809d9177640a20" # us-west-1
}

variable "APP" {
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

variable "PRIVATE_KEY_PATH" {
  default = "ec2-key-pair"
}

variable "PUBLIC_KEY_PATH" {
  default = "ec2-key-pair.pub"
}

variable "EC2_USER" {
  default = "ubuntu"
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "VOLUME_TYPE" {
  default = "gp2"
}

variable "VOLUME_SIZE" {
  default = 20
}

variable "VOLUME_DELETE" {
  default = true
}
