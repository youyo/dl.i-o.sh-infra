resource "aws_cloudtrail" "cloudtrail" {
  name                          = "cloudtrail"
  enable_logging                = true
  s3_bucket_name                = "${aws_s3_bucket.aws-dl-i-o-sh-logs.id}"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}
