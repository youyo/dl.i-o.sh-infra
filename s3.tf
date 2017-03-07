resource "aws_s3_bucket" "terraform-tfstate-dl-i-o-sh" {
  bucket = "terraform-tfstate-dl.i-o.sh"
  acl    = "private"
  region = "${var.aws_region}"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id = "remove versioninged file"

    prefix  = ""
    enabled = true

    noncurrent_version_expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket" "dl-i-o-sh" {
  bucket = "dl.i-o.sh"
  acl    = "public-read"
  region = "${var.aws_region}"
  policy = "${file("policies/s3_static_website_hosting.json")}"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id = "remove versioninged file"

    prefix  = ""
    enabled = true

    noncurrent_version_expiration {
      days = 90
    }
  }

  logging {
    target_bucket = "${aws_s3_bucket.aws-dl-i-o-sh-logs.id}"
    target_prefix = "s3/dl.i-o.sh/"
  }

  depends_on = ["aws_s3_bucket.aws-dl-i-o-sh-logs"]
}

resource "aws_s3_bucket" "aws-dl-i-o-sh-logs" {
  bucket = "dl.i-o.sh-logs"
  acl    = "log-delivery-write"
  policy = "${file("policies/log_bucket.json")}"

  lifecycle_rule {
    id      = "remove old log files"
    prefix  = ""
    enabled = true

    expiration {
      days = 90
    }
  }
}
