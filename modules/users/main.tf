resource "aws_iam_user" "admin_users" {
  count = "${length(var.admin_users)}"
  name  = "${element(var.admin_users, count.index)}"
  path  = "/itcloud/admin/"

  force_destroy = true
}

data "aws_caller_identity" "current" {}

data "template_file" "mfa" {
  template = "${file("${path.module}/mfa-policy.json.tmpl")}"

  vars {
    account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_iam_policy" "mfa" {
  name        = "mfa-access"
  description = "Policy that enforces MFA access"
  policy      = "${data.template_file.mfa.rendered}"
}

resource "aws_iam_group" "mfa-users" {
  name = "mfa-users"
}

resource "aws_iam_policy_attachment" "mfa" {
  groups     = ["${aws_iam_group.mfa-users.name}"]
  policy_arn = "${aws_iam_policy.mfa.arn}"
}

resource "aws_iam_role" "admin" {
  count = "${length(split(",",var.admin_users))}"
  path  = "/itcloud/admin/"
  name  = "${element(split(",",var.admin_users), count.index)}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal" : { "AWS" : "${element(aws_iam_user.admin.*.arn, count.index)}" },
      "Effect": "Allow",
      "Sid": "${element(split(",",var.admin_users), count.index)}"
    }
  ]
}
EOF
}
