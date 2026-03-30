variable "APP_NAME" {
  default = "ecs-asg"
}

variable "AWS_REGION" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "IMAGE_URI" {
  description = "ECR image URI (e.g. 123456.dkr.ecr.us-west-2.amazonaws.com/app:latest)"
  default     = "smarman/go-site-gin:9330d6c1c974960cd154320dd93c8f138162faf3-arm64"      
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