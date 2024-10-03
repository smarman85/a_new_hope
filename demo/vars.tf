variable "AWS_REGION" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "AWS_PROFILE" {
  description = "AWS profile"
  default     = "newlab"
}

variable "AMI" {
  description = "AMI ID"
  default     = "ami-012bf399e76fe4368" # arm64 - ubuntu 22.04
}

variable "VPCID" {
  description = "VPC ID"
  default     = "vpc-0d1fc9b3e71b3f53c"
}

variable "SUBNET_IDS" {
  description = "ids of the subnets"
  default     = ["subnet-0abadf507a966ef94", "subnet-02761483d5106d500", "subnet-02e71f8f7e13858f8", "subnet-0941da01b13b48fa6"]
}
variable "INSTANCE_TYPE" {
  description = "Instance type"
  default     = "t4g.small"
}

variable "PUBLIC_KEY_PATH" {
  default = "homelab-west-2.pub"
}

variable "DNS_NAME" {
  default = "seanmarman.com"
}
