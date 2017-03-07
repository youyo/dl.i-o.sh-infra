resource "aws_sns_topic" "billing" {
  provider = "aws.ailas_us_east_1"
  name     = "BillingAlarm"
}
