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

variable "cidr_access" {
  default = "0.0.0.0/0"
}

variable "name" {
  default = "devEnv"
}

variable "public" {
  default = true
}
