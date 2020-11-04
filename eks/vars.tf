variable "AWS_REGION" {
  default = "us-east-1"
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

variable "CIDR_SUBNET" {
  default = "10.0.1.0/24"
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
