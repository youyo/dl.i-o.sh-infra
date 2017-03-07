# ec2
resource "aws_instance" "dl-i-o-sh" {
  ami                    = "ami-c55673a0"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.vpc-dl-i-o-sh-public-subnet1.id}"
  availability_zone      = "${aws_subnet.vpc-dl-i-o-sh-public-subnet1.availability_zone}"
  vpc_security_group_ids = ["${aws_security_group.dl-i-o-sh-sg.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  key_name                    = "${aws_key_pair.default_key.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.ec2_instance_role_dl-i-o-sh.name}"
  disable_api_termination     = true
  associate_public_ip_address = true

  tags {
    Name = "dl.i-o.sh"
  }
}

# ebs
resource "aws_ebs_volume" "volume_dl-i-o-sh_data" {
  availability_zone = "${aws_subnet.vpc-dl-i-o-sh-public-subnet1.availability_zone}"
  size              = 5
  type              = "standard"

  tags {
    Name = "volume_dl-i-o-sh_data"
  }
}

resource "aws_volume_attachment" "volume_dl-i-o-sh_data_attach" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.volume_dl-i-o-sh_data.id}"
  instance_id = "${aws_instance.dl-i-o-sh.id}"
}

# elastic ip
resource "aws_eip" "eip_dl-i-o-sh" {
  vpc = true
}

resource "aws_eip_association" "eip_dl-i-o-sh_assoc" {
  instance_id   = "${aws_instance.dl-i-o-sh.id}"
  allocation_id = "${aws_eip.eip_dl-i-o-sh.id}"
}

# key pair
resource "aws_key_pair" "default_key" {
  key_name   = "default_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClVm7p5ckjmscB4gfJrI9O9Pa7Wo/7VEVkkgACZut7xBDK7dpD2wsavCUe9s2Ll4jFDc4UjsvypgPYhAGu3k9tGb8v7ysPHC2ZMh1zCdqrvuNMl+w3EnoEJW9iY5/NgCT807TqW890CUww3rHAYyyB0msmN62UgHdELFQHWAa7wNcQeTPUG0r8FaxwTYiMAtKoHz9YQMQJdDrTd6UmOSBWx0SEyBk0RL5v9kWzz4hIsQV80psDcDoSxrj37fSkG3oZDu7sG2owjAaxG5bKgQ3g9e953LnGEiI8ywHVeerL/A1cZTWcoM91aqyiT3goLF7dQFzXzL3iw3OQN/BL3ExN"
}

# instance role
resource "aws_iam_role_policy_attachment" "ec2_role_dl-i-o-sh_attach" {
  role       = "${aws_iam_role.ec2_role_dl-i-o-sh.name}"
  policy_arn = "${aws_iam_policy.inaccessible_policy.arn}"
}

resource "aws_iam_instance_profile" "ec2_instance_role_dl-i-o-sh" {
  name  = "ec2_instance_role_dl-i-o-sh"
  roles = ["${aws_iam_role.ec2_role_dl-i-o-sh.name}"]
}
