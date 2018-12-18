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
  path  = "/${var.iam_path_prefix}/users/"

  tags = {
    Name      = "${element(var.users, count.index)}"
    Terraform = "true"
    Service   = "IAM"
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

resource "aws_iam_group_policy_attachment" "mfa" {
  group      = "${aws_iam_group.mfa-users.name}"
  policy_arn = "${aws_iam_policy.mfa.arn}"
}

resource "aws_iam_group_membership" "users" {
  name = "group-membership"

  users = [
    "${aws_iam_user.users.*.name}",
  ]

  group = "${aws_iam_group.mfa-users.name}"
}

data "aws_iam_policy_document" "role_assumption" {
  count = "${length(var.users)}"

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${element(aws_iam_user.users.*.arn, count.index)}"]
    }
  }
}

resource "aws_iam_role" "admin" {
  path               = "/${var.iam_path_prefix}/AdminRole/"
  name               = "AdminRole"
  assume_role_policy = "${data.aws_iam_policy_document.role_assumption.json}"

  tags = {
    Name      = "AdminRole"
    Terraform = "true"
    Purpose   = "IAM Role user"
    Service   = "IAM"
  }
}

resource "aws_iam_role" "readonly" {
  path               = "/${var.iam_path_prefix}/ReadOnly/"
  name               = "ReadOnlyRole"
  assume_role_policy = "${data.aws_iam_policy_document.role_assumption.json}"

  tags = {
    Name      = "ReadOnlyRole"
    Terraform = "true"
    Purpose   = "IAM Readonly role"
    Service   = "IAM"
  }
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = "${aws_iam_role.admin.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role       = "${aws_iam_role.readonly.name}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
