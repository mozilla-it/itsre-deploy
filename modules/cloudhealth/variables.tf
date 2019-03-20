variable "cloudhealth_role_name" {
  description = "Name of cloudhealth role"
  default     = "cloud_health_role"
}

variable "cloudhealth_external_id" {
  description = "External ID for IAM role, this can be obtained from cloudhealth website"
}
