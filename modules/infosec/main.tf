provider "aws" {
  version = "~> 1"
  region  = "${var.region}"
}

resource "aws_cloudtrail" "opsec-cloudtrail" {
  count                         = "${var.enabled}"
  name                          = "opsec-cloudtrail"
  s3_bucket_name                = "${var.cloudtrail_bucket}"
  sns_topic_name                = "${var.cloudtrail_sns_topic}"
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_logging                = true
  enable_log_file_validation    = true
}

resource "aws_cloudformation_stack" "opsec" {
  count = "${var.enabled}"
  name  = "opsec"

  capabilities = [
    "CAPABILITY_IAM",
  ]

  template_body = "${file("${path.module}/audit.yaml")}"

  parameters = {
    EmailAddress = "${var.notify_address}"
  }
}
