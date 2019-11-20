variable  network_cidr {}
variable region {}
variable dns_zone {}
# Remove profile  after test
provider aws {
    region = "${var.region}"
}
# Retrieve vpc data for vpc_id 
data "aws_vpc" "selected" {
  cidr_block = "${var.network_cidr}"
}
# Private subnet_ids
##################################
data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.selected.id}"
  tags = {
    SubnetTier = "Private"
  }
}
data "aws_subnet" "private" {
  count = "${length(tolist(data.aws_subnet_ids.private.ids))}"
  id    = "${element(tolist(data.aws_subnet_ids.private.ids),count.index)}"
}
output "private_subnet_ids" {
  value = "${data.aws_subnet_ids.private.ids}"
}
# Public subnet_ids
##################################
data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.selected.id}"
  tags = {
    SubnetTier = "Public"
  }
}
data "aws_subnet" "public" {
  count = "${length(tolist(data.aws_subnet_ids.public.ids))}"
  id    = "${element(tolist(data.aws_subnet_ids.public.ids),count.index)}"
}
output "public_subnet_ids" {
  value = "${data.aws_subnet_ids.public.ids}"
}
# Public Availability zones
#############################################
# Expected to return 3 or more availability zones -if more we like to fail here than later. 
output "availability_zones" {
  value = "${data.aws_subnet.public.*.availability_zone}"
}
# Public Availability zones
#############################################
output "private_availability_zones" {
  value = "${data.aws_subnet.private.*.availability_zone}"
}
output "network_cidr" {
    value = "${var.network_cidr}"
}
output "region" {
    value = "${var.region}"
}
output "vpc_id" {
    value = "${data.aws_vpc.selected.id}"
}
output "dns_zone" {
    // value = "${data.aws_route53_zone.selected.name}"
    value = "${var.dns_zone}"
}