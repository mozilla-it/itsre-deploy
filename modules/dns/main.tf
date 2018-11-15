resource "aws_route53_delegation_set" "default" {
  lifecycle {
    create_before_destroy = true
  }

  reference = "default"
}

locals {
  zone_name = "${var.account_name}.${var.domain}"
}

resource "aws_route53_zone" "main" {
  name              = "${local.zone_name}"
  delegation_set_id = "${aws_route53_delegation_set.default.id}"
  tags              = "${merge(map("Name", "${var.account_name}-zone", "Region", "core"), var.tags)}"
}

resource "aws_route53_record" "main-ns" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${local_zone_name}"
  type    = "NS"
  ttl     = "${var.zone_ttl}"

  records = [
    "${aws_route53_zone.main.name_servers}",
  ]
}
