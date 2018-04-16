output "vpc_id" { value = "${aws_vpc.this.id}" }
output "private_1a_id" { value = "${aws_subnet.private_1a.id}" }
output "private_1b_id" { value = "${aws_subnet.private_1b.id}" }
output "public_1a_id" { value = "${aws_subnet.public_1a.id}" }
output "public_1b_id" { value = "${aws_subnet.public_1b.id}" }
output "igw_id" {value = "${aws_internet_gateway.gw.id}"}
output "ngw_id" {value = "${aws_nat_gateway.gw.id}"}