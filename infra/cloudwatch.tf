resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/capstone/app"
  retention_in_days = 14

  tags = {
    Name = "capstone-log-group"
  }
}

resource "aws_cloudwatch_metric_alarm" "asg_unhealthy_instances" {
  alarm_name          = "asg-unhealthy-instances"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "GroupTotalInstances"
  namespace           = "AWS/AutoScaling"
  period              = 60
  statistic           = "Average"
  threshold           = 0

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }

  alarm_description = "Triggers if the Auto Scaling Group has no healthy in-service instances"
  alarm_actions     = [aws_sns_topic.alerts.arn]

  tags = {
    Name = "asg-unhealthy-alarm"
  }
}