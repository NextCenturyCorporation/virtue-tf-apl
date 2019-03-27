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



// !!!!!!!!!!!!!!!!Sensor Monitor!!!!!!!!!!!!!!!!!!!!! 


resource "aws_instance" "twoSix_virtue_monitor_master2" {
  ami           = "ami-0f9cf087c1f27d9b1"
  instance_type = "m4.2xlarge"
  key_name      = "twosix_ec2"

  subnet_id              = "${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["sg-fb7adab3", "sg-c1d38a88", "${aws_security_group.default_sg.id}", "${aws_security_group.virtue_internalports_dev_sg.id}"]

  disable_api_termination = "true"  

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "120"
    delete_on_termination = true
  }

  tags {
    Name = "Sensing Monitor Master 2"
  }



  lifecycle {
    prevent_destroy = false
  }
}


//!!!!!!!!!!!!!!!End of Sensor Monitor !!!!!!!!!!!!!!!!!!!!!!!!!

// !!!!!!!!!!!!!!!!This is for Virtue BackEnd Administration!!!!!!!!!!!!!!!!!!!!! 
resource "aws_instance" "ncc_virtue-admin2" {
  ami           = "ami-c6ad16b9" // This ami is preinstalled with virtue-admin base ami is "ami-71b7750b" there is a new one  ami-4f87273
  instance_type = "t2.xlarge"
  key_name      = "vrtu"

  subnet_id = "${module.vpc.public_1a_id}"

  //Note sg-c1d38a88 is the open-vpn security group created by APL. We need to add this manually. 
  //not
  #vpc_security_group_ids = ["sg-c1d38a88", "${aws_security_group.default_sg.id}", "${ aws_security_group.virtue_internalports_dev_sg.id}", "${ aws_security_group.virtue_admin_server_internal_sg.id}", "${ aws_security_group.virtue_admin_server_external_sg.id}"]
  
  vpc_security_group_ids = ["${aws_security_group.virtue_open_all.id}", "${aws_security_group.virtue_internalports_dev_sg.id}" ]
  iam_instance_profile = "SAVIOR_ADMIN_SERVER"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "120"
    delete_on_termination = true
  }

  tags {
    Name = "Virtue BackEnd Admin 2"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_instance" "all-c5IntegrationInstanceTemp" {
  ami           = "ami-0d48c2470c8bdc875"     
  instance_type = "t3.medium"
  key_name      = "virginiatech_ec2"

  #vpc_security_group_ids = ["sg-dd5104af"] 
  subnet_id              = "subnet-3171986d" #"${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["sg-fb7adab3", "sg-c1d38a88", "${aws_security_group.default_sg.id}", "${aws_security_group.virtue_internalports_dev_sg.id}"]

  #user_data = "${file("./user-data-files/generic_config.yaml")}"
  associate_public_ip_address = true
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "120"
    delete_on_termination = true
  }

  tags {
    Name = "NCC Xen Image Configure 4.18-Wole "
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = ["user_data"]
  }
}


resource "aws_instance" "ncc_dev_win" {
  ami           = "ami-04410717f23954994" // VirtueIntegrationWindows2_v1_20180522_0405am_apl
  instance_type = "t2.large"
  key_name      = "vrtu"

  subnet_id = "${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["${aws_security_group.default_sg.id}", "${ aws_security_group.virtue_internalports_dev_sg.id}", "${ aws_security_group.virtue_twosix_dev_sg.id}", "${ aws_security_group.rdp_sg.id}", "${aws_security_group.virtue_VTinternalports_dev_sg.id}"]

  tags {
    Name = "NCC Windows Dev Box - Wole"
  }

  lifecycle {
    prevent_destroy = false
  }
}



resource "aws_instance" "ncc_virtue-syslogredirect" {
  ami           = "ami-0f1f1c12347a0736e" 
  instance_type = "t3.medium"
  key_name      = "vrtu"

   
  subnet_id              = "${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["${aws_security_group.virtue_open_all.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "80"
    delete_on_termination = true
  }

  tags {
    Name = "NCC Virtue Syslog Redirect - Wole"
  }
}



resource "aws_instance" "ncc_virtue_admin" {
  ami           = "ami-0ac019f4fcb7cb7e6" 
  instance_type = "t3.large"
  key_name      = "vrtu"

   
  subnet_id              = "${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["${aws_security_group.virtue_open_all.id}", "${aws_security_group.virtue_internalports_dev_sg.id}"]
  iam_instance_profile = "SAVIOR_ADMIN_SERVER"

  disable_api_termination = true
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "80"
    delete_on_termination = true
  }

  tags {
    Name = "NCC Virtue Admin with CIF - Wole"
  }
}


resource "aws_instance" "ncc_virtue-adminworkbench" {
  ami           = "ami-0ac019f4fcb7cb7e6" 
  instance_type = "t3.medium"
  key_name      = "vrtu"

   
  subnet_id              = "${module.vpc.public_1a_id}"
  #vpc_security_group_ids = ["${aws_security_group.default_sg.id}", "${ aws_security_group.virtue_internalports_dev_sg.id}", "${ aws_security_group.virtue_server_sg.id}"]
  vpc_security_group_ids = ["${aws_security_group.virtue_open_all.id}", "${aws_security_group.virtue_internalports_dev_sg.id}"]

  //This EC2-SERVER-ADMIN iam role was created by hand. 
  #iam_instance_profile =  "EC2-SERVER-ADMIN"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "120"
    delete_on_termination = true
  }

  tags {
    Name = "NCC Virtue Admin Workbench - Wole"
  }
}






resource "aws_instance" "all-t3IntegrationDom0Instance_master" {

  ami = "ami-0cba37c29a34aea81"
  instance_type = "t3.medium"
  key_name      = "virginiatech_ec2"

   
  subnet_id              = "${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["sg-0df52ca023344f1dc","sg-01fa789e839e9445e", "${aws_security_group.default_sg.id}", "${aws_security_group.virtue_internalports_dev_sg.id}", "${aws_security_group.virtue_testportforwarding_dev_sg.id}"]

  iam_instance_profile     =      "S3FullAccess"
  disable_api_termination  =     "true" 
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "120"
    delete_on_termination = true
  }

  tags {
    Name = "NCC Xen Image Configure - Wole"
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = ["user_data"]
  }
}





resource "aws_route53_record" "sensing-api" {
  zone_id = "${aws_route53_zone.savior.zone_id}"
  name    = "sensing-api.savior.internal"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.twoSix_virtue_monitor_master2.private_dns}"]
}

resource "aws_route53_record" "sensing-ca" {
  zone_id = "${aws_route53_zone.savior.zone_id}"
  name    = "sensing-ca.savior.internal"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.twoSix_virtue_monitor_master2.private_dns}"]
}

resource "aws_route53_record" "sensing-kafka" {
  zone_id = "${aws_route53_zone.savior.zone_id}"
  name    = "sensing-kafka.savior.internal"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.twoSix_virtue_monitor_master2.private_dns}"]
}

//!!!!!!!!!!!!!!!!! End of TwoSix Instance !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 


/*
resource "aws_eip" "virtue_admin_eip" {
  instance = "${aws_instance.ncc_virtue-admin.id}"
  vpc      = true
}
*/


/*
resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "S3_ReadOnlyX"
  assume_role_policy = 
}
*/
