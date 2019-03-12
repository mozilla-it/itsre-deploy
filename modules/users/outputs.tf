output "AdminRoleARN" {
  value = "${element(concat(aws_iam_role.admin.*.arn, list("")), 0)}"
}

output "ReadOnlyRoleARN" {
  value = "${element(concat(aws_iam_role.readonly.*.arn, list("")), 0)}"
}

output "users" {
  value = ["${aws_iam_user.users.*.name}"]
}

output "accesskeys" {
  value = ["${aws_iam_access_key.users.*.id}"]
}

output "secretkeys" {
  value = ["${aws_iam_access_key.users.*.secret}"]
}
