data "aws_iam_policy_document" "billing-readonly" {
  statement {
    effect = "Allow"

    actions = [
      "aws-portal:ViewAccount",
      "aws-portal:ViewBilling",
      "aws-portal:ViewPaymentMethods",
      "aws-portal:ViewUsage",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "billing-readonly" {
  count       = var.enabled ? 1 : 0
  name        = "BillingReadonly"
  path        = "/"
  description = "Readonly access to Account billing"
  policy      = data.aws_iam_policy_document.billing-readonly.json
}

