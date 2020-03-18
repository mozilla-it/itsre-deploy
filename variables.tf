variable "region" {
  default = "us-west-2"
}

variable "account_name" {
}

variable "admin_users" {
  type    = list(string)
  default = ["elim", "eziegenhorn", "kferrando", "sidler", "adelbarrio", "afrank"]
}

variable "delegated_account_ids" {
  type    = list(string)
  default = ["921547910285", "177680776199"]
}

variable "features" {
  default = {
    users    = false
    vpc      = false
    dns      = false
    maws     = false
    infosec  = true
    account  = true
    policies = true
  }
}

variable "users" {
  default = {
    create_access_keys           = true
    write_access_files           = true
    create_delegated_permissions = false
  }
}

variable "vpc" {
  default = {
    name                        = "main-vpc"
    vpc_cidr                    = "172.16.0.0/16"
    az_placement                = "3"
    enable_nat_gateway          = true
    enable_single_nat_gateway   = true
    enable_multiple_nat_gateway = false
    enable_dynamodb_endpoint    = false
    enable_s3_endpoint          = false
  }
}

variable "cloudhealth" {
  default = {
    role_name   = "cloud_health_role"
    external_id = "62f85b3d4efcbeb2b360ae857fec1e" # pragma: allowlist secret
  }
}

variable "infosec" {
  default = {
    bucket    = "mozilla-cloudtrail-logs"
    sns_topic = "arn:aws:sns:us-west-2:088944123687:MozillaCloudTrailLogs"
  }
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

