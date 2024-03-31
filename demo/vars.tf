variable "AWS_REGION" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "AWS_PROFILE" {
  description = "AWS profile"
  default     = "homelab"
}

variable "AMI" {
  description = "AMI ID"
  default     = "ami-012bf399e76fe4368" # arm64 - ubuntu 22.04
}

variable "VPCID" {
  description = "VPC ID"
  default     = "vpc-a91193d1"

}

variable "INSTANCE_TYPE" {
  description = "Instance type"
  default     = "t4g.small"
}

variable "PUBLIC_KEY_PATH" {
  default = "homelab-west-2.pub"
}