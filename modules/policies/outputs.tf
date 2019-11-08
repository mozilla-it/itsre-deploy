output "billing_readonly_policy_arn" {
  value = "${aws_iam_policy.billing-readonly.*.arn}"
}
