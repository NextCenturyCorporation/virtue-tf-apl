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
/*
data "aws_vpc_endpoint" "s3" {
  vpc_id = "${module.vpc.vpc_id}"
  service_name = "com.amazonaws.us-west-2.s3"
}
*/

/*
resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = "${data.aws_vpc_endpoint.s3a.id}"
  route_table_id  = "${aws_route_table.private_routes.id}"
}

*/