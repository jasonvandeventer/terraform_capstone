resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/capstone/app"
  retention_in_days = 14

  tags = {
    Name = "capstone-log-group"
  }
}

resource "aws_cloudwatch_metric_alarm" "asg_unhealthy_instances" {
  count               = var.low_cost ? 0 : 1
  alarm_name          = "UnhealthyInstancesAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnhealthyHostCount"
  namespace           = "AWS/AutoScaling"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg[0].name
  }
}
