# provider
variable "aws_region" {
  default = "us-east-2"
}

# billing alert
variable "billing_count" {
  default = 3
}

variable "billing_threshold" {
  default {
    "0" = 1
    "1" = 5
    "2" = 15
  }
}
