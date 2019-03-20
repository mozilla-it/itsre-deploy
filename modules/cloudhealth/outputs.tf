output "cloudhealth_assume_role_arn" {
  value = "${module.cloudhealth.cloudhealth-role-arn}"
}

output "cloudhealth_assume_role_external_id" {
  value = "${module.cloudhealth.external-id}"
}

output "cloudhealth_policy_arn" {
  value = "${module.cloudhealth.cloudhealth-policy-arn}"
}
