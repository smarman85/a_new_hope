variable "appName" {
  type = "string"
}

variable "internal" {
  type = "bool"
}

variable "lbType" {
  type = "string"
}

variable "securityGroups" {
  type = list(string)
}

variable "subnetID" {
  type = list(string)
}
