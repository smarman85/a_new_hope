variable "AWS_PROFILE" {
  default = "homelab"
}
variable "AWS_REGION" {
  default = "us-east-1"
}
variable "count" {
    default = 1
}
variable "region" {
  description = "AWS region for hosting our your network"
  default = "us-east-1"
}
variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
  default = "/srv/infrastructure/ec2-key-pair"
}
variable "key_name" {
  description = "Key name for SSHing into EC2"
  default = "ec2-key-pair"
}
variable "amis" {
  description = "Base AMI to launch the instances"
  default = {
  us-east-1 = "ami-0c2a1acae6667e438"
  }
}
