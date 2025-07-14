resource "aws_sns_topic" "alerts" {
  count = var.low_cost ? 0 : 1
  name  = "capstone-alerts"
}

resource "aws_sns_topic_subscription" "email_alert" {
  count     = var.low_cost || length(var.alert_email) == 0 ? 0 : 1
  topic_arn = aws_sns_topic.alerts[0].arn
  protocol  = "email"
  endpoint  = var.alert_email
}