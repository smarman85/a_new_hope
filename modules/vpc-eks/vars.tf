variable "region" {
  type        = string
  description = "Main region"
}

variable "cidr_vpc" {
  type        = string
  description = "Block of IP addresses your vpc will have access too"
}

variable "cidr_subnet1" {
  type        = string
  description = "Block of IP addresses in your subnet"
}

variable "cidr_subnet2" {
  type        = string
  description = "Block of IP addresses in your subnet"
}

variable "cidr_access" {
  type        = string
  description = "Block of IP addresses to allow access from"
}

variable "app_name" {
  type        = string
  description = "Name of your application"
}

variable "public" {
  type        = string
  description = "If you want to open your subnet traffic to the internet"
}
