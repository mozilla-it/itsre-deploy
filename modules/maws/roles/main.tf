data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/auth.mozilla.auth0.com/"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "auth.mozilla.auth0.com/:aud"
      values   = var.idp_client_id
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "auth.mozilla.auth0.com/:amr"
      values   = var.role_mapping
    }
  }
}

locals {
  default_tags = {
    Service   = "MAWS"
    Terraform = "true"
  }
}

resource "aws_iam_role" "admin" {
  count                = var.enabled ? 1 : 0
  name                 = "maws-admin"
  description          = "MAWS role for admin, managed by Terraform"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    {
      "Name" = "maws-admin"
    },
    local.default_tags
  )
}

resource "aws_iam_role" "poweruser" {
  count                = var.enabled ? 1 : 0
  name                 = "maws-poweruser"
  description          = "MAWS role for poweruser, managed by Terraform"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    {
      "Name" = "maws-poweruser"
    },
    local.default_tags
  )
}

resource "aws_iam_role" "readonly" {
  count                = var.enabled ? 1 : 0
  name                 = "maws-readonly"
  description          = "MAWS role for readonly, managed by Terraform"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    {
      "Name" = "maws-readonly"
    },
    local.default_tags
  )
}

resource "aws_iam_role" "viewonly" {
  count                = var.enabled ? 1 : 0
  name                 = "maws-viewonly"
  description          = "MAWS role for viewonly, managed by Terraform"
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    {
      "Name" = "maws-viewonly"
    },
    local.default_tags
  )
}

resource "aws_iam_role_policy_attachment" "admin" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.admin[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "poweruser" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.poweruser[0].name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "readonly" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.readonly[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "viewonly" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.viewonly[0].name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}
