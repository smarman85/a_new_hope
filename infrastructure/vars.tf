variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMI" {
  default = "ami-0c2a1acae6667e438"
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
