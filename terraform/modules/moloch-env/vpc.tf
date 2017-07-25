resource "aws_vpc" "moloch_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags {
      Name = "moloch_vpc-${var.environment_name}"
      Environment = "${var.environment_name}"
      Role = "networking"
    }
}

resource "aws_internet_gateway" "vpc_gw" {
    vpc_id = "${aws_vpc.moloch_vpc.id}"
}

resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.moloch_vpc.id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "${var.aws_region}a"

    tags {
      Name = "private_subnet-${var.environment_name}"
      Environment = "${var.environment_name}"
      Role = "networking"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = "${aws_vpc.moloch_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.vpc_gw.id}"
    }

    tags {
      Name = "public_rt-${var.environment_name}"
      Environment = "${var.environment_name}"
      Role = "networking"
    }
}

resource "aws_route_table_association" "public_rta" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.public_rt.id}"
}
