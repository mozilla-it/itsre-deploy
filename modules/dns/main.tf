resource "aws_route53_delegation_set" "default" {
  count = var.enabled ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  reference_name = "default"
}

locals {
  zone_name = "${var.account_name}.${var.domain}"
}

resource "aws_route53_zone" "main" {
  count             = var.enabled ? 1 : 0
  name              = local.zone_name
  delegation_set_id = element(aws_route53_delegation_set.default.*.id, count.index)
  tags = merge(
    {
      "Name"   = "${var.account_name}-zone"
      "Region" = "core"
    },
    var.tags,
  )
}

