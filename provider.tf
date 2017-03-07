provider "aws" {
  region = "${var.aws_region}"
}

provider "aws" {
  region = "us-east-1"
  alias  = "ailas_us_east_1"
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "ailas_ap_northeast_1"
}

provider "fastly" {}
