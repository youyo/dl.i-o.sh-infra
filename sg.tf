resource "aws_security_group" "dl-i-o-sh-sg" {
  name   = "dl.i-o.sh_sg"
  vpc_id = "${aws_vpc.vpc-dl-i-o-sh.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["${data.fastly_ip_ranges.fastly.cidr_blocks}", "0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  description = "dl.i-o.sh_sg"
}
