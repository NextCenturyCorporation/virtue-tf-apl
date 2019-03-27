#
# Copyright (C) 2019 Next Century Corporation
# 
# This file may be redistributed and/or modified under either the GPL
# 2.0 or 3-Clause BSD license. In addition, the U.S. Government is
# granted government purpose rights. For details, see the COPYRIGHT.TXT
# file at the root of this project.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.
# 
# SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
#
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