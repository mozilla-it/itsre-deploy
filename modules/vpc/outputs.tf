output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "cidr_block" {
  value = "${aws_vpc.default.cidr_block}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.default.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "default_security_group_id" {
  value = "${aws_security_group.default.id}"
}

output "nat_gateway_ids" {
  value = ["${aws_nat_gateway.nat_gw.*.id}"]
}

output "nat_security_group_id" {
  value = "${aws_security_group.nat.id}"
}

output "availability_zones" {
  value = "${var.availability_zones}"
}
