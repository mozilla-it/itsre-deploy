variable "enabled" {}

variable "region" {
  default = "us-west-2"
}

variable "name" {}

variable "environment" {
  default = "core"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = "list"
}

variable "newbits" {
  default     = 8
  description = "number of bits to add to the vpc cidr when building subnets"
}

variable "az_number" {
  default = {
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
    f = 6
  }
}

variable "public_netnum_offset" {
  default = 0
}

variable "private_netnum_offset" {
  default = 100
}

variable "tags" {
  default = {}
  type    = "map"
}
