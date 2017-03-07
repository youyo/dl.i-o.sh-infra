resource "fastly_service_v1" "dl-i-o-sh" {
  name = "dl.i-o.sh"

  domain {
    name    = "dl.i-o.sh"
    comment = "dl.i-o.sh"
  }

  backend {
    address = "${aws_eip.eip_dl-i-o-sh.public_ip}"
    name    = "dl.i-o.sh"
    port    = 80
  }

  default_host  = "dl.i-o.sh"
  force_destroy = false

  s3logging {
    name        = "fastly-dl.i-o.sh"
    bucket_name = "${aws_s3_bucket.aws-dl-i-o-sh-logs.id}"
    path        = "fastly/"
    domain      = "${var.aws_region}.amazonaws.com"
  }
}

data "fastly_ip_ranges" "fastly" {}
