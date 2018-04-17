output "vpc_id" {
  value = "${aws_vpc.this.id}"
}

output "public_1a_id" {
  value = "${aws_subnet.public_1a.id}"
}

output "igw_id" {
  value = "${aws_internet_gateway.gw.id}"
}
