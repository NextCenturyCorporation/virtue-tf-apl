resource "aws_vpc" "this" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.vpc_name}"
  }
}
data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_1a" {
  vpc_id     = "${aws_vpc.this.id}"
  cidr_block = "${var.vpc_public_1a_subnet}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"
  tags {
    Name = "Public_1a"
  }
}


resource "aws_subnet" "public_1b" {
  vpc_id     = "${aws_vpc.this.id}"
  cidr_block = "${var.vpc_public_1b_subnet}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"
  tags {
    Name = "Public_1b"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.this.id}"

  tags {
    Name = "main IGW"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id     = "${aws_vpc.this.id}"
  cidr_block = "${var.vpc_private_1a_subnet}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "Private_1a"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id     = "${aws_vpc.this.id}"
  cidr_block = "${var.vpc_private_1b_subnet}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"

  tags {
    Name = "Private_1b"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public_1a.id}"

  tags {
    Name = "gw NAT"
  }
}


