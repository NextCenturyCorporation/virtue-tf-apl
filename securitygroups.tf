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

locals {
  default_cidr_blocks = ["111.111.111.111/32"]
}

resource "aws_security_group" "default_sg" {
  name        = "default_sg_vpc"
  description = "Rules for SSH and egress"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${local.default_cidr_blocks}"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    self      = "true"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "default_sg"
  }
}

resource "aws_security_group" "rdp_sg" {
  name        = "rdp_sg_vpc"
  description = "Rules for SSH and egress"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = "${local.default_cidr_blocks}"
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "udp"
    cidr_blocks = "${local.default_cidr_blocks}"
  }

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "tcp"
    self      = "true"
  }

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "udp"
    self      = "true"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "rdp_sg"
  }
}


resource "aws_security_group" "default_rdp_sg" {
  name        = "default_windows_rdp"
  description = "allow windows rdp"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = "${local.default_cidr_blocks}"
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "udp"
    cidr_blocks = "${local.default_cidr_blocks}"
  }

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "tcp"
    self      = "true"
  }

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "udp"
    self      = "true"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Windows RDP"
  }
}

/*
This security group is for the Virtue Server running rest services. It needs port 
8080, 8443 to be open. 
*/
resource "aws_security_group" "virtue_admin_server_external_sg" {
  name        = "virtue_admin_server_external_sg_vpc"
  description = "Rules for http, https"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = "${local.default_cidr_blocks}"
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = "${local.default_cidr_blocks}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "virtue_admin_server_external_sg"
  }
}

/*
This security group is for the Virtue Server running rest services. It needs port 
8080, 8443 to be open. 
*/
resource "aws_security_group" "virtue_admin_server_internal_sg" {
  name        = "virtue_admin_server_internal_sg_vpc"
  description = "Rules for http, https"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    self      = "true"
  }

  ingress {
    from_port = 8443
    to_port   = 8443
    protocol  = "tcp"
    self      = "true"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "virtue_admin_server_internal_sg"
  }
}

resource "aws_security_group" "virtue_postgreSQL_sg" {
  name        = "virtue_postgreSQL_sg_vpc"
  description = "Rules for Postgress"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = "${local.default_cidr_blocks}"
  }

  tags {
    Name = "virtue_postgress_sg"
  }
}

resource "aws_security_group" "virtue_twosix_dev_sg" {
  name        = "virtue TwoSix dev security group"
  description = "Rules for Two Six sensor communications"
  vpc_id      = "${module.vpc.vpc_id}"

  //9555/tcp: Kafka TLS
  ingress {
    from_port = 9555
    to_port   = 9555
    protocol  = "tcp"
    self      = "true"
  }

  //17141/tcp: Sensing API HTTP
  ingress {
    from_port = 17141
    to_port   = 17141
    protocol  = "tcp"
    self      = "true"
  }

  //17504/tcp: Sensing API HTTPS/TLS
  ingress {
    from_port = 17504
    to_port   = 17504
    protocol  = "tcp"
    self      = "true"
  }

  //11000 - 11100/tcp (Sensor HTTPS actuation)
  ingress {
    from_port = 11000
    to_port   = 11100
    protocol  = "tcp"
    self      = "true"
  }

  //11000 - 11100/tcp (Sensor HTTPS actuation)
  ingress {
    from_port = 11000
    to_port   = 11100
    protocol  = "tcp"
    self      = "true"
  }

  /*******This is between API Swarm Hosts******/
  //80, 443, 2377, 17141, and 17504


  /*
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = "true"
  }
  */

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "virtue_twosix_dev_sg"
  }
}

resource "aws_security_group" "virtue_VTinternalports_dev_sg" {
  name        = "virtue internal open NFS ports for development security group"
  description = "Rules to open internal ports"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    self      = "true"
  }

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "udp"
    self      = "true"
  }

  ingress {
    from_port = 111
    to_port   = 111
    protocol  = "tcp"
    self      = "true"
  }

  ingress {
    from_port = 111
    to_port   = 111
    protocol  = "udp"
    self      = "true"
  }

  ingress {
    from_port = 5000
    to_port   = 5000
    protocol  = "udp"
    self      = "true"
  }

  ingress {
    from_port = 5000
    to_port   = 5000
    protocol  = "tcp"
    self      = "true"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = "true"
  }

  tags {
    Name = "virtue_VTinternalports_dev_sg"
  }
}

resource "aws_security_group" "virtue_internalports_dev_sg" {
  name        = "virtue internal open all port  for development security group"
  description = "Rules to open internal ports"
  vpc_id      = "${module.vpc.vpc_id}"

  /***********Ports needed for communication between Sensor API and VMs******************/
  //9555/tcp: Kafka TLS
  ingress {
    from_port = 9555
    to_port   = 9555
    protocol  = "tcp"
    self      = "true"
  }

  //17141/tcp: Sensing API HTTP
  ingress {
    from_port = 17141
    to_port   = 17141
    protocol  = "tcp"
    self      = "true"
  }

  //17504/tcp: Sensing API HTTPS/TLS
  ingress {
    from_port = 17504
    to_port   = 17504
    protocol  = "tcp"
    self      = "true"
  }

  //11000 - 11100/tcp (Sensor HTTPS actuation)
  ingress {
    from_port = 11000
    to_port   = 11100
    protocol  = "tcp"
    self      = "true"
  }

  /*******This is between API Swarm Hosts******/
  //2181/tcp, 2181/udp: Used by Zookeeper and Kafka for service management
  ingress {
    from_port = 2181
    to_port   = 2181
    protocol  = "tcp"
    self      = "true"
  }

  //2181/tcp, 2181/udp: Used by Zookeeper and Kafka for service management
  ingress {
    from_port = 2181
    to_port   = 2181
    protocol  = "udp"
    self      = "true"
  }

  //2377/tcp, 2377/udp: Used by Docker Swarm for cluster management
  ingress {
    from_port = 2377
    to_port   = 2377
    protocol  = "tcp"
    self      = "true"
  }

  //2377/tcp, 2377/udp: Used by Docker Swarm for cluster management
  ingress {
    from_port = 2377
    to_port   = 2377
    protocol  = "udp"
    self      = "true"
  }

  //4789/tcp, 4789/udp: Used by Docker Swarm overlay network
  ingress {
    from_port = 4789
    to_port   = 4789
    protocol  = "tcp"
    self      = "true"
  }

  //4789/tcp, 4789/udp: Used by Docker Swarm overlay network
  ingress {
    from_port = 4789
    to_port   = 4789
    protocol  = "udp"
    self      = "true"
  }

  //5000/tcp: Temporary Docker Registry port for container distribution to Docker Swarm nodes
  ingress {
    from_port = 5000
    to_port   = 5000
    protocol  = "tcp"
    self      = "true"
  }

  //7946/tcp, 7946/udp: Docker Swarm control traffic
  ingress {
    from_port = 7946
    to_port   = 7946
    protocol  = "tcp"
    self      = "true"
  }

  //7946/tcp, 7946/udp: Docker Swarm control traffic
  ingress {
    from_port = 7946
    to_port   = 7946
    protocol  = "udp"
    self      = "true"
  }

  //9455/tcp: Swarm internal port for Kafka communication
  ingress {
    from_port = 9455
    to_port   = 9455
    protocol  = "tcp"
    self      = "true"
  }

  //9455/tcp: Swarm internal port for Kafka communication
  ingress {
    from_port = 9555
    to_port   = 9555
    protocol  = "tcp"
    self      = "true"
  }

  //17141/tcp: Sensing API Insecure port
  ingress {
    from_port = 17141
    to_port   = 17141
    protocol  = "tcp"
    self      = "true"
  }

  //17504/tcp: Sensing API Secure port
  ingress {
    from_port = 17504
    to_port   = 17504
    protocol  = "tcp"
    self      = "true"
  }

  //12000-12012 for portfwarding for dom0
  ingress {
    from_port = 12000
    to_port   = 12012
    protocol  = "tcp"
    self      = "true"
  }

  //Port 8001 if the ssh port into domU
  ingress {
    from_port = 8001
    to_port   = 8010
    protocol  = "tcp"
    self      = "true"
  }

  //Port 8001 if the ssh port into domU
  ingress {
    from_port = 514
    to_port   = 514
    protocol  = "tcp"
    self      = "true"
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = "true"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "virtue_internalports_dev_sg"
  }
}

resource "aws_security_group" "virtue_testportforwarding_dev_sg" {
  name        = "Port forwarding Test"
  description = "Rules to open internal ports"
  vpc_id      = "${module.vpc.vpc_id}"

  /*Port 8001 if the ssh port into domU*/
  ingress {
    from_port = 8001
    to_port   = 8001
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "SshForwardPorts" {
  name        = "SshForwardPorts"
  description = "Port forwarding 8001-8010"
  vpc_id      = "${module.vpc.vpc_id}"

  /*Port 8001 if the ssh port into domU*/
  ingress {
    from_port = 8001
    to_port   = 8010
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//Name: virtue_open_all
//Function: This security group opens all ports. Use for just debugging. 
resource "aws_security_group" "virtue_open_all" {
  name        = "Open All Ports"
  description = "Rules to open internal ports"
  vpc_id      = "${module.vpc.vpc_id}"

  /*Port 8001 if the ssh port into domU*/
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
