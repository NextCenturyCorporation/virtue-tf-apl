module "vpc" {
  source                = "./vpc"
  vpc_cidr              = "10.0.0.0/16"
  vpc_private_1a_subnet = "10.0.0.0/23"
  vpc_private_1b_subnet = "10.0.2.0/23"
  vpc_public_1a_subnet  = "10.0.4.0/23"
  vpc_public_1b_subnet  = "10.0.6.0/23"
  vpc_name              = "VIRTUE"
}

resource "aws_route_table" "public_routes" {
  vpc_id = "${module.vpc.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${module.vpc.igw_id}"
  }
}

resource "aws_route_table" "private_routes" {
  vpc_id = "${module.vpc.vpc_id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${module.vpc.ngw_id}"
  }
}

resource "aws_route_table_association" "public_1a_routes" {
  subnet_id      = "${module.vpc.public_1a_id}"
  route_table_id = "${aws_route_table.public_routes.id}"
}

resource "aws_route_table_association" "public_1b_routes" {
  subnet_id      = "${module.vpc.public_1b_id}"
  route_table_id = "${aws_route_table.public_routes.id}"
}

resource "aws_route_table_association" "private_1a_routes" {
  subnet_id      = "${module.vpc.private_1a_id}"
  route_table_id = "${aws_route_table.private_routes.id}"
}

resource "aws_route_table_association" "private_1b_routes" {
  subnet_id      = "${module.vpc.private_1b_id}"
  route_table_id = "${aws_route_table.private_routes.id}"
}
