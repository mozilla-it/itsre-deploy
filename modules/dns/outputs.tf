output "hosted_zone_id" {
  value = "${aws_route53_zone.main.*.zone_id}"
}

output "master_zone_nameservers" {
  value = "${flatten(aws_route53_zone.main.*.name_servers)}"
}

# Should only ever have 1 master zone so we assume
# and take the first element
output "master_zone_name" {
  value = "${aws_route53_zone.main.0.name}"
}
