variable "account_name" {}

variable "domain" {
  default = "mozit.cloud"
}

variable "zone_ttl" {
  default = "30"
}

variable "tags" {
  default = {}
  type    = "map"
}
