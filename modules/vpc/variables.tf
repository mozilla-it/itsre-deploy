variable "region" {
  default = "us-west-2"
}

variable "module_version" {
  default = "1.46.0"
}

variable "enable_vpc" {
  default = true
}

variable "name" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "az_placement" {
  description = "How many AZs do you want to place subnets in"
}

variable "enable_nat_gateway" {
  default = true
}

variable "single_nat_gateway" {
  default = true
}

variable "one_nat_gateway_per_az" {
  default = true
}

variable "tags" {
  default = {}
  type    = "map"
}

variable "newbits" {
  default = "4"
}

variable "enable_s3_endpoint" {
  default = true
}

variable "enable_dynamodb_endpoint" {
  default = true
}
