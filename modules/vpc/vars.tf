variable "CIDR_VPC" {
  type        = string
  description = "Block of IP addresses your vpc will have access too"
}

variable "CIDR_SUBNET" {
  type        = string
  description = "Block of IP addresses in your subnet"
}

variable "CIDR_ACCESS" {
  type        = string
  description = "Block of IP addresses to allow access from"
}

variable "APP_NAME" {
  type        = string
  description = "Name of your application"
}

variable "PUBLIC" {
  type        = bool
  description = "If you want to open your subnet traffic to the internet"
}
