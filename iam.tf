# terraform_administrator
resource "aws_iam_policy" "administrator" {
  name        = "administrator"
  description = "administrator"
  path        = "/"
  policy      = "${file("policies/administrator.json")}"
}

resource "aws_iam_user" "terraform_administrator" {
  name = "terraform_administrator"
}

resource "aws_iam_policy_attachment" "terraform_administrator_attach" {
  name = "terraform_administrator_attach"

  users = [
    "${aws_iam_user.terraform_administrator.name}",
  ]

  policy_arn = "${aws_iam_policy.administrator.arn}"
}

resource "aws_iam_access_key" "terraform_administrator_key" {
  user = "${aws_iam_user.terraform_administrator.name}"
}

# terraform_fastly_logging
resource "aws_iam_policy" "fastly_logging" {
  name        = "fastly_logging"
  description = "fastly_logging"
  path        = "/"
  policy      = "${file("policies/fastly_logging.json")}"
}

resource "aws_iam_user" "terraform_fastly_logging" {
  name = "terraform_fastly_logging"
}

resource "aws_iam_policy_attachment" "terraform_fastly_logging_attach" {
  name = "terraform_fastly_logging_attach"

  users = [
    "${aws_iam_user.terraform_fastly_logging.name}",
  ]

  policy_arn = "${aws_iam_policy.fastly_logging.arn}"
}

resource "aws_iam_access_key" "terraform_fastly_logging_key" {
  user = "${aws_iam_user.terraform_fastly_logging.name}"
}

# inaccessible
resource "aws_iam_policy" "inaccessible_policy" {
  name        = "instance_role_policy"
  description = "instance_role_policy"
  policy      = "${file("policies/inaccessible.json")}"
}

# assume role ec2
resource "aws_iam_role" "ec2_role_dl-i-o-sh" {
  name               = "ec2_role_dl-i-o-sh"
  assume_role_policy = "${file("policies/ec2_instance_role.json")}"
}
