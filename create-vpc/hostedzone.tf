variable zone_name {
  default = "dev.stem.com"
}

resource "aws_route53_zone" "private" {
  name = "${var.zone_name}"

  vpc {
    vpc_id = "${aws_vpc.customvpc.id}"
  }
}
