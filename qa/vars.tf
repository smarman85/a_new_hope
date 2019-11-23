variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AWS_PROFILE" {
  default = "dev"
}

variable "cidr_vpc" {
  default = "10.0.0.0/16"
}

variable "cidr_subnet" {
  default = "10.0.1.0/24"
}

variable "cidr_ingress" {
  default = "0.0.0.0/0"
}

variable "firewall_ingress" {
  default = ["0.0.0.0/0"]
}

variable "firewall_egress" {
  default = ["0.0.0.0/0"]
}

variable "name" {
  default = "devEnv"
}

variable "public" {
  default = true
}

variable "ami_ID" {
  default = "ami-0c2a1acae6667e438"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_user" {
  default = "ubuntu"
}

variable "priv_key" {
  default = "ec2-key-pair"
}

variable "pub_key" {
  default = "ec2-key-pair.pub"
}

variable "provision_script" {
  default = "docker.sh"
}
