output "AdminRoleARN" {
  value = "${aws_iam_role.admin.arn}"
}

output "ReadOnlyRoleARN" {
  value = "${aws_iam_role.readonly.arn}"
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
