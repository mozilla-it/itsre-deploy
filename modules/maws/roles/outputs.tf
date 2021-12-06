output "adminrolearn" {
  value = aws_iam_role.admin.*.arn
}

output "readonlyrolearn" {
  value = aws_iam_role.readonly.*.arn
}


output "poweruserrolearn" {
  value = aws_iam_role.poweruser.*.arn
}

output "viewonlyrolearn" {
  value = aws_iam_role.viewonly.*.arn
}

output "assume_role_json" {
  value = data.aws_iam_policy_document.assume_role.json
}
