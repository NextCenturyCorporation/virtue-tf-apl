// !!!!!!!!!!!!!!!!This is for Virginia Tech - DO NOT DELETE!!!!!!!!!!!!!!!!!!!!! 
resource "aws_instance" "all-c5IntegrationInstance" {
  ami           = "ami-5529f22a"     //AMI with xen running on c5
  instance_type = "c5.xlarge"
  key_name      = "virginiatech_ec2"

  subnet_id              = "${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["${aws_security_group.default_sg.id}", "${aws_security_group.virtue_internalports_dev_sg.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "120"
    delete_on_termination = false
  }

  tags {
    Name = "NCC Integration - All Teams"
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = ["user_data"]
  }
}

resource "aws_instance" "all-IntegrationInstance_win" {
  ami           = "ami-cab14db7" //ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126
  instance_type = "t2.micro"
  key_name      = "vrtu"

  subnet_id              = "${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["${aws_security_group.default_sg.id}", "${ aws_security_group.virtue_twosix_dev_sg.id}", "${ aws_security_group.rdp_sg.id}"]

  tags {
    Name = "NCC Integration Windows - All Teams"
  }

  lifecycle {
    prevent_destroy = false
  }
}

// !!!!!!!!!!!!!!!!Sensor Monitor!!!!!!!!!!!!!!!!!!!!! 
resource "aws_instance" "twoSix_virtue_1" {
  ami           = "ami-4ee34631"
  instance_type = "m4.large"
  key_name      = "twosix_ec2"

  subnet_id              = "${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["${aws_security_group.default_sg.id}", "${ aws_security_group.virtue_internalports_dev_sg.id}"]

  #user_data = "${file("./user-data-files/generic_config.yaml")}"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "120"
    delete_on_termination = true
  }

  tags {
    Name = "Virtue Sensor Monitor 1"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_instance" "twoSix_virtue_2" {
  ami           = "ami-cce247b3"
  instance_type = "m4.large"
  key_name      = "twosix_ec2"

  subnet_id              = "${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["${aws_security_group.default_sg.id}", "${ aws_security_group.virtue_internalports_dev_sg.id}"]

  #user_data = "${file("./user-data-files/generic_config.yaml")}"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "120"
    delete_on_termination = true
  }

  tags {
    Name = "Virtue Sensor Monitor 2"
  }

  lifecycle {
    prevent_destroy = false

    #    ignore_changes = ["user_data"]
  }
}

resource "aws_instance" "twoSix_virtue_3" {
  ami           = "ami-cce247b3"
  instance_type = "m4.large"
  key_name      = "twosix_ec2"

  subnet_id              = "${module.vpc.public_1a_id}"
  vpc_security_group_ids = ["${aws_security_group.default_sg.id}", "${ aws_security_group.virtue_internalports_dev_sg.id}"]

  #user_data = "${file("./user-data-files/generic_config.yaml")}"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "120"
    delete_on_termination = true
  }

  tags {
    Name = "Virtue Sensor Monitor 3"
  }

  lifecycle {
    prevent_destroy = false
  }
}

// !!!!!!!!!!!!!!!!End of Sensor Monitor!!!!!!!!!!!!!!!!!!!!! 

// !!!!!!!!!!!!!!!!This is for Virtue BackEnd Administration!!!!!!!!!!!!!!!!!!!!! 
resource "aws_instance" "ncc_virtue-admin" {
  ami           = "ami-71b7750b" //ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126
  instance_type = "t2.xlarge"
  key_name      = "vrtu"

  subnet_id = "${module.vpc.public_1a_id}"

  //Note that Virtue Admin needs ports 8080 and 8443.
  vpc_security_group_ids = ["${aws_security_group.default_sg.id}", "${ aws_security_group.virtue_internalports_dev_sg.id}", "${ aws_security_group.virtue_admin_server_internal_sg.id}", "${ aws_security_group.virtue_admin_server_external_sg.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "120"
    delete_on_termination = true
  }

  tags {
    Name = "Virtue BackEnd Admin"
  }

  lifecycle {
    prevent_destroy = false
  }
}

// !!!!!!!!!!!!!!!!End of Virtue BackEnd Administration!!!!!!!!!!!!!!!!!!!!! 

resource "aws_instance" "ncc_win_integration" {
  ami           = "ami-cfcd68b0" //ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180126
  instance_type = "m5.large"
  key_name      = "vrtu"

  #vpc_security_group_ids = ["sg-dd5104af"] 
  subnet_id = "${module.vpc.public_1a_id}"

  vpc_security_group_ids = ["${aws_security_group.default_sg.id}", "${ aws_security_group.virtue_internalports_dev_sg.id}", "${ aws_security_group.virtue_twosix_dev_sg.id}", "${ aws_security_group.rdp_sg.id}", "${aws_security_group.virtue_VTinternalports_dev_sg.id}"]

  #user_data = "${file("./user-data-files/generic_config.yaml")}"

  tags {
    Name = "NCC TestX Windows - Wole"
  }
  lifecycle {
    prevent_destroy = false

    #    ignore_changes = ["user_data"]
  }
}

resource "aws_route53_record" "sensing-api" {
  zone_id = "${aws_route53_zone.savior.zone_id}"
  name    = "sensing-api.savior.internal"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.twoSix_virtue_1.private_dns}"]
}

resource "aws_route53_record" "sensing-ca" {
  zone_id = "${aws_route53_zone.savior.zone_id}"
  name    = "sensing-ca.savior.internal"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.twoSix_virtue_1.private_dns}"]
}

resource "aws_route53_record" "sensing-kafka" {
  zone_id = "${aws_route53_zone.savior.zone_id}"
  name    = "sensing-kafka.savior.internal"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.twoSix_virtue_1.private_dns}"]
}

//!!!!!!!!!!!!!!!!! End of TwoSix Instance !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

resource "aws_eip" "virtue_admin_eip" {
  instance = "${aws_instance.ncc_virtue-admin.id}"
  vpc      = true
}
