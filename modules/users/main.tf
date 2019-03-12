data "aws_caller_identity" "current" {}

locals {
  create_users            = "${var.create_users ? 1 : 0}"
  create_access_keys      = "${var.create_access_keys ? 1 : 0}"
  write_access_files      = "${var.write_access_files ? 1 : 0}"
  delegated_admin_arn     = "${formatlist("arn:aws:iam::%s:role/itsre-admin", var.delegated_account_ids)}"
  delegated_readonly_arn  = "${formatlist("arn:aws:iam::%s:role/itsre-readonly", var.delegated_account_ids)}"
  delegated_poweruser_arn = "${formatlist("arn:aws:iam::%s:role/itsre-poweruser", var.delegated_account_ids)}"
}

# NOTE: When you switch the paths around the template needs its path
# replaced as well, need to fix this to better detect that
data "template_file" "mfa" {
  template = "${file("${path.module}/templates/mfa-policy.json.tmpl")}"

  vars {
    path_prefix = "${var.iam_path_prefix}"
    account_id  = "${data.aws_caller_identity.current.account_id}"
  }
}

data "aws_iam_policy_document" "group-sts" {
  statement {
    sid     = "AllowIndividualUserToAssumeRole"
    actions = ["sts:AssumeRole"]

    resources = [
      "${aws_iam_role.admin.arn}",
      "${aws_iam_role.readonly.arn}",
      "${local.delegated_admin_arn}",
      "${local.delegated_readonly_arn}",
      "${local.delegated_poweruser_arn}",
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_user" "users" {
  count = "${length(var.users) * local.create_users}"
  name  = "${element(var.users, count.index)}"
  path  = "/${var.iam_path_prefix}/users/"

  tags = {
    Name      = "${element(var.users, count.index)}"
    Terraform = "true"
    Service   = "IAM"
  }
}

resource "aws_iam_access_key" "users" {
  count = "${length(var.users) * local.create_users * local.create_access_keys}"
  user  = "${element(var.users, count.index)}"
}

resource "aws_iam_policy" "mfa" {
  name        = "mfa"
  description = "Policy that enforces MFA access"
  policy      = "${data.template_file.mfa.rendered}"
}

resource "aws_iam_group" "mfa-users" {
  name = "mfa-users"
  path = "/${var.iam_path_prefix}/"
}

resource "aws_iam_group_policy_attachment" "mfa" {
  group      = "${aws_iam_group.mfa-users.name}"
  policy_arn = "${aws_iam_policy.mfa.arn}"
}

resource "aws_iam_group_policy" "group-sts" {
  name   = "sts-allow"
  group  = "${aws_iam_group.mfa-users.name}"
  policy = "${data.aws_iam_policy_document.group-sts.json}"
}

resource "aws_iam_group_membership" "users" {
  count = "${local.create_users}"
  name  = "group-membership"

  users = [
    "${aws_iam_user.users.*.name}",
  ]

  group = "${aws_iam_group.mfa-users.name}"
}

data aws_iam_policy_document "sts" {
  count = "${local.create_users}"

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${formatlist("%s", aws_iam_user.users.*.arn)}"]
    }
  }
}

resource "aws_iam_role" "admin" {
  count              = "${local.create_users}"
  path               = "/${var.iam_path_prefix}/"
  name               = "AdminRole"
  description        = "Admin role managed by Terraform"
  assume_role_policy = "${element(data.aws_iam_policy_document.sts.*.json, count.index)}"

  tags = {
    Name      = "AdminRole"
    Terraform = "true"
    Purpose   = "IAM Role user"
    Service   = "IAM"
  }
}

resource "aws_iam_role" "readonly" {
  count              = "${local.create_users}"
  path               = "/${var.iam_path_prefix}/"
  name               = "ReadOnlyRole"
  description        = "ReadOnly role managed by Terraform"
  assume_role_policy = "${element(data.aws_iam_policy_document.sts.*.json, count.index)}"

  tags = {
    Name      = "ReadOnlyRole"
    Terraform = "true"
    Purpose   = "IAM Readonly role"
    Service   = "IAM"
  }
}

resource "aws_iam_role_policy_attachment" "admin" {
  count      = "${local.create_users}"
  role       = "${element(aws_iam_role.admin.*.name, count.index)}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "readonly" {
  count      = "${local.create_users}"
  role       = "${aws_iam_role.readonly.name}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data template_file "init" {
  count    = "${length(var.users) * local.create_users * local.write_access_files}"
  template = "${file("${path.module}/templates/users.json")}"

  vars = {
    username              = "${element(aws_iam_access_key.users.*.user, count.index)}"
    aws_access_key_id     = "${element(aws_iam_access_key.users.*.id, count.index)}"
    aws_secret_access_key = "${element(aws_iam_access_key.users.*.secret, count.index)}"
  }
}

resource "local_file" "this" {
  count    = "${length(var.users) * local.create_users * local.write_access_files}"
  content  = "${element(data.template_file.init.*.rendered, count.index)}"
  filename = "${path.cwd}/${element(var.users, count.index)}-iam.json"
}
