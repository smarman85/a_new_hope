variable "AMI_ID" {
  type = string
  description = "AMI id to build from"
}

variable "INSTANCE_TYPE" {
  type = string
  description = "AWS Instance type"
}

variable "SUBNET_ID" {
  type = string
  description = "ID of the subnet the ec2 will be attached to"
}

variable "VPC_SECURITY_GROUP" {
  type = list(string)
  description = "Security Group the ec2 will belong to"
}

variable "EC2_USER" {
  type = string
  description = "Name of the EC2 user"
}

variable "PRIVATE_KEY" {
  type = string
  description = "Location of the ssh private key"
}

variable "PUBLIC_KEY_PATH" {
  type = string
  description = "Location of the ssh public key"
}

variable "PROVISIONER_FILE" {
  type = string
  description = "Location of the ec2 provisioner file"
}
