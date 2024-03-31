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
  default     = "vpc-0383bf86cc653d623"
}

variable "SUBNET_IDS" {
  description = "ids of the subnets"
  default     = ["subnet-055fbd12c979eb3f1", "subnet-0664277e014c37667", "subnet-05980c1ea1627636e", "subnet-01737b0ab548d9664"]
}
variable "INSTANCE_TYPE" {
  description = "Instance type"
  default     = "t4g.small"
}

variable "PUBLIC_KEY_PATH" {
  default = "homelab-west-2.pub"
}