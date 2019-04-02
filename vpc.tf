module "vpc" {
  source               = "./vpc"
  vpc_cidr             = "10.0.0.0/16"
  vpc_public_1a_subnet = "10.0.4.0/23"
  vpc_name             = "VIRTUE"
}

//This is an internet routing table.  
resource "aws_route_table" "public_routes" {
  vpc_id = "${module.vpc.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${module.vpc.igw_id}"
  }
}