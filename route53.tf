resource "aws_route53_zone" "savior" {
  name   = "savior.internal"
  vpc_id = "${module.vpc.vpc_id}"
}
