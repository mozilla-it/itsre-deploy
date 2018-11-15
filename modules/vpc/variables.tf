variable "name" {}

variable "environment" {
  default = "core"
}

variable "vpc_cidr" {
  default = "10.0.0.0/8"
}

variable "tags" {
  default = {}
  type    = "map"
}
