resource "aws_vpc" "vpc-dl-i-o-sh" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "vpc-dl.i-o.sh"
  }
}

resource "aws_vpc_dhcp_options" "vpc-dl-i-o-sh-dhcp-opt" {
  domain_name         = "${var.aws_region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name = "vpc-dl.i-o.sh-dhcp-opt"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.vpc-dl-i-o-sh.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.vpc-dl-i-o-sh-dhcp-opt.id}"
}

resource "aws_internet_gateway" "vpc-dl-i-o-sh-igw" {
  vpc_id = "${aws_vpc.vpc-dl-i-o-sh.id}"

  tags {
    Name = "igw-dl.i-o.sh"
  }
}

resource "aws_subnet" "vpc-dl-i-o-sh-public-subnet1" {
  vpc_id            = "${aws_vpc.vpc-dl-i-o-sh.id}"
  cidr_block        = "10.10.10.0/24"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "public-subnet1-dl.i-o.sh"
  }
}

resource "aws_subnet" "vpc-dl-i-o-sh-public-subnet2" {
  vpc_id            = "${aws_vpc.vpc-dl-i-o-sh.id}"
  cidr_block        = "10.10.11.0/24"
  availability_zone = "${var.aws_region}c"

  tags {
    Name = "public-subnet2-dl.i-o.sh"
  }
}

resource "aws_default_route_table" "vpc-dl-i-o-sh-public-rt" {
  default_route_table_id = "${aws_vpc.vpc-dl-i-o-sh.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc-dl-i-o-sh-igw.id}"
  }

  tags {
    Name = "public-rt-dl.i-o.sh"
  }
}

resource "aws_route_table_association" "vpc-dl-i-o-sh-rta1" {
  subnet_id      = "${aws_subnet.vpc-dl-i-o-sh-public-subnet1.id}"
  route_table_id = "${aws_default_route_table.vpc-dl-i-o-sh-public-rt.id}"
}

resource "aws_route_table_association" "vpc-dl-i-o-sh-rta2" {
  subnet_id      = "${aws_subnet.vpc-dl-i-o-sh-public-subnet2.id}"
  route_table_id = "${aws_default_route_table.vpc-dl-i-o-sh-public-rt.id}"
}

resource "aws_default_network_acl" "vpc-dl-i-o-sh-default-acl" {
  default_network_acl_id = "${aws_vpc.vpc-dl-i-o-sh.default_network_acl_id}"

  subnet_ids = [
    "${aws_subnet.vpc-dl-i-o-sh-public-subnet1.id}",
    "${aws_subnet.vpc-dl-i-o-sh-public-subnet2.id}",
  ]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "default-acl-dl.i-o.sh"
  }
}

resource "aws_default_security_group" "vpc-dl-i-o-sh-default-sg" {
  vpc_id = "${aws_vpc.vpc-dl-i-o-sh.id}"

  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    self      = true
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "default-sg-dl.i-o.sh"
  }
}
