resource "aws_iam_account_alias" "alias" {
  account_alias = "${var.account_name}"
  count         = "${var.enabled}"
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length      = 16
  max_password_age             = 90
  password_reuse_prevention    = 24
  require_lowercase_characters = true
  require_numbers              = true
  require_uppercase_characters = true
}
