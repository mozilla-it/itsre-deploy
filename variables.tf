variable "region" {
  default = "us-west-2"
}

variable "account_name" {
}

variable "admin_users" {
  type    = list(string)
  default = ["elim", "adelbarrio"]
}

variable "features" {
  description = "List of features to enable, look at local.tf for full list of values"
  type        = map(string)
  default     = {}
}

variable "users" {
  default = {
    create_access_keys           = true
    write_access_files           = true
    create_delegated_permissions = false
  }
}

variable "vpc" {
  description = "VPC settings"
  type        = map(string)
  default     = {}
}

variable "maws" {
  description = "MAWS setting"
  type        = map(string)
  default     = {}
}

variable "cloudhealth" {
  description = "Cloudhealth role settings"
  type        = map(string)
  default     = {}
}

variable "infosec" {
  description = "Infosec module settings"
  type        = map(string)
  default     = {}
}

variable "default_tags" {
  default = {
    Region           = "us-west-2"
    TechnicalContact = "infra-aws@mozilla.com"
    Terraform        = "true"
  }
}

variable "kubernetes_tags" {
  default = {}
  type    = map(string)
}

