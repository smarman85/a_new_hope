variable "clusterName" {
  type = string
  description = "Name of the cluster this will run in"
}

variable "instance_types" {
  type = string
  description = "Type of ec2 instances"
}

variable "desiredSize" {
  type = number
  description = "How many nodes this will run at any time"
}

variable "maxSize" {
  type = number
  description = "Max ammount of nodes"
}

variable "subnets" {
  type = string
  description = "Subets available to the nodes"
}
