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

//This private route is used for our subnet since it cannot get 
//directly to the interent. So we have to use a NAT getway. 
resource "aws_route_table" "private_routes" {
  vpc_id = "${module.vpc.vpc_id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${module.vpc.ngw_id}"
  }


  tags {
    Name = "Route traffic to NAT Gateway"
  }

}

//We do manual association on APL AWS since we have to integrate 
//with APL routes. 

/*
resource "aws_route_table_association" "public_1a_routes" {
    subnet_id = "${module.vpc.public_1a_id}"
    route_table_id = "${aws_route_table.private_routes.id}"
}
*/


/*resource "aws_route_table_association" "public_1a_routes" {
  subnet_id = "${module.vpc.public_1a_id}"

  //This rtb-4b141e37 is the virtue-rt that was created manually in 
  //aws console. 
  route_table_id = "rtb-4b141e37"

  //route_table_id = "${aws_route_table.public_routes.id}"
}
*/