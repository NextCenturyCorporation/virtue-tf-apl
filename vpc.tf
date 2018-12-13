module "vpc" {
  source               = "./vpc"
  vpc_cidr             = "10.0.0.0/16"
  vpc_public_1a_subnet = "10.0.4.0/23"
  vpc_name             = "VIRTUE"
}

resource "aws_route_table" "public_routes" {
  vpc_id = "${module.vpc.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${module.vpc.igw_id}"
  }
}
/*resource "aws_route_table_association" "public_1a_routes" {
  subnet_id = "${module.vpc.public_1a_id}"

  //This rtb-4b141e37 is the virtue-rt that was created manually in 
  //aws console. 
  route_table_id = "rtb-4b141e37"

  //route_table_id = "${aws_route_table.public_routes.id}"
}
*/