variable "region" {
  default = "us-west-2"
}

variable "enabled" {}

variable "role_mapping" {
  type        = list(string)
  description = "The Mozilla LDAP or Mozillians group name to grant access to the roles"
  default = [
    "team_se",
    "mozilliansorg_web-sre-aws-access"
  ]
}

variable "idp_client_id" {
  default = "N7lULzWtfVUDGymwDs0yDEq6ZcwmFazj" #pragma: allowlist secret
}

variable "max_session_duration" {
  default = "43200" # 12 hours
}
