variable "create_users" {
  description = "Toggle to create user or do nothing"
  default     = true
}

variable "create_access_keys" {
  description = "Toggle to create IAM Access Key"
  default     = true
}

variable "write_access_files" {
  description = "Write out access files"
  default     = true
}

variable "users" {
  type = "list"
}

variable "iam_path_prefix" {
  default = "itsre"
}

variable "delegated_account_ids" {
  type = "list"
}
