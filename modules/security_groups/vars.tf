variable "VPC_ID" {
  type = string
  description = "ID for the VPC to attach the rules too"
}

variable "CIDR_OUTBOUND" {
  type = list(string)
  description = "IPs to allow outbound traffic too"
}

variable "CIDR_ACCESS" {
  type = list(string)
  description = "IPs to allow inbound traffic from"
}

variable "APP_NAME" {
  type = string
  description = "IPs to allow inbound traffic from"
}
