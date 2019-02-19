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
/*
resource "aws_route_table" "private_routes" {
  vpc_id = "${module.vpc.vpc_id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${module.vpc.ngw_id}"
  }

  route {
    cidr_block = "10.200.0.0/30"
    network_interface_id = "eni-0fb67112acf4c0d31"
  }

  route {
    cidr_block = "128.244.0.0/16"
    gateway_id  = "igw-1367e66b"
  }

  route {
    cidr_block = "192.168.4.0/24"
    network_interface_id = "eni-0fb67112acf4c0d31"
  }

  
  tags {
    Name = "virtue-route-public-2b"
  }

}
*/