variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMI" {
  #default = "ami-0c2a1acae6667e438"
  default = "ami-07ebfd5b3428b6f4d"
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

variable "AWS_PROFILE" {
  default = "homelab"
}

variable "VPC_SUBNET_ID" {
  default = "VPC_SUBNET_ID"
}

variable "SUBNET_ID" {
  default = "subnet-09b4b021b3f529bd6"
}

variable "VPC_SECURITY_GROUP" {
  default = "sg-074595c48510a50c0"
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
  default = "docker"
}
