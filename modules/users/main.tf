data "aws_caller_identity" "current" {}

data "template_file" "mfa" {
  template = "${file("${path.module}/mfa-policy.json.tmpl")}"

  vars {
    account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_iam_user" "users" {
  count = "${length(var.users)}"
  name  = "${element(var.users, count.index)}"
  path  = "/itcloud/users/"
}

resource "aws_iam_policy" "mfa" {
  name        = "mfa-access"
  description = "Policy that enforces MFA access"
  policy      = "${data.template_file.mfa.rendered}"
}

resource "aws_iam_group" "mfa-users" {
  name = "mfa-users"
}

resource "aws_iam_group_policy_attachment" "mfa" {
  groups     = ["${aws_iam_group.mfa-users.name}"]
  policy_arn = "${aws_iam_policy.mfa.arn}"
}

resource "aws_iam_role" "admin" {
  count = "${length(var.users)}"
  path  = "/itcloud/AdminRole/"
  name  = "${element(var.users, count.index)}"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal" : { "AWS" : "${element(aws_iam_user.users.*.arn, count.index)}" },
        "Effect": "Allow",
        "Sid": "${element(var.users, count.index)}"
      }
    ]
  }
EOF
}

resource "aws_iam_role" "readonly" {
  path = "/itcloud/readonly/"
  name = "readonly"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal" : { "AWS" : [ ${formatlist("\"%s\"", aws_iam_user.users.*.arn)} ]},
      "Effect": "Allow",
      "Sid": "readonly"
    }
  ]
}
EOF
}
