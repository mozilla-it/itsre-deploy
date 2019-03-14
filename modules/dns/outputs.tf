output "hosted_zone_id" {
  value = "${aws_route53_zone.main.*.zone_id}"
}

output "master_zone_nameservers" {
  value = "${join(",", aws_route53_zone.main.*.name_servers)}"
}
