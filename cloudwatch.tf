resource "aws_cloudwatch_metric_alarm" "billing" {
  provider            = "aws.ailas_us_east_1"
  alarm_name          = "Billing Alert lv.${count.index + 1} (${lookup(var.billing_threshold, count.index)} USD)"
  namespace           = "AWS/Billing"
  metric_name         = "EstimatedCharges"
  statistic           = "Maximum"
  evaluation_periods  = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "21600"
  threshold           = "${lookup(var.billing_threshold, count.index)}"

  dimensions {
    "Currency" = "USD"
  }

  alarm_description = "Total Charge ${lookup(var.billing_threshold, count.index)} USD"
  alarm_actions     = ["${aws_sns_topic.billing.arn}"]
  count             = "${var.billing_count}"
}
