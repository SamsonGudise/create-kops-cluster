variable cidr_block {
    default = "10.16.0.0/16"
}
variable pub_subnetlist {
    default =  ["10.16.1.0/24", "10.16.2.0/24","10.16.3.0/24"]
    type = "list"
}

variable private_subnetlist {
    default =  ["10.16.4.0/24", "10.16.5.0/24","10.16.6.0/24"]
    type = "list"
}

variable availability_zone {
    type = "list"
    default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}


resource "aws_vpc" "customvpc" {
	cidr_block = "${var.cidr_block}"
	enable_dns_support = true
	enable_dns_hostnames = true
	tags = {
		Name = "stem-testvpc"
		Purpose = "SamsonGudise"
		Owner = "Samson"
		terraform = true
	}
}

resource "aws_subnet" "services-pri-subnets" {
    count = 3
    vpc_id = "${aws_vpc.customvpc.id}"
    availability_zone = "${element(var.availability_zone,count.index)}"
    cidr_block = "${element(var.private_subnetlist,count.index)}"
    map_public_ip_on_launch = false
    tags = {
        SubnetType = "Private"
    }
}

resource "aws_subnet" "services-pub-subnets" {
    count = 3
    vpc_id = "${aws_vpc.customvpc.id}"
    availability_zone = "${element(var.availability_zone,count.index)}"
    cidr_block = "${element(var.pub_subnetlist,count.index)}"
    map_public_ip_on_launch = true

    tags = {
        SubnetType = "Public"
    }
}

resource "aws_route_table" "new" {
  count = 2 
  vpc_id = "${aws_vpc.customvpc.id}"
  tags = {
    Purpose = "SamsonTest"
  }
}

resource "aws_eip" "nat" {}

## Create NAT Gateway
resource "aws_nat_gateway" "gw" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id     = "${aws_subnet.services-pub-subnets.*.id[0]}"
    tags = {
        Name = "services-nat"
    }
}

## Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.customvpc.id}"

  tags = {
    Name = "services"
  }
}

########
resource "aws_route" "igw" {
  route_table_id            = "${aws_route_table.new.*.id[0]}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
  depends_on = [ "aws_route_table.new", "aws_internet_gateway.main" ]
}

## Create Default route for Private subnets 
resource "aws_route" "nat" {
  route_table_id            = "${aws_route_table.new.*.id[1]}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.gw.id}"
  depends_on = [ "aws_route_table.new", "aws_nat_gateway.gw" ]
}

resource "aws_route_table_association" "private" {
  count = 3
  subnet_id     = "${element(aws_subnet.services-pri-subnets.*.id,count.index)}"
  route_table_id = "${aws_route_table.new.*.id[1]}"
}

resource "aws_route_table_association" "public" {
  count = 3
  subnet_id     = "${element(aws_subnet.services-pub-subnets.*.id,count.index)}"
  route_table_id = "${aws_route_table.new.*.id[0]}"
}