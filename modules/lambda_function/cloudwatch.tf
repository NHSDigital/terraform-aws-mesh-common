
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 90
  tags = {
    Name = "/aws/lambda/${var.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_metric_alarm" {
  count               = length(var.alarm_actions) > 0 ? 1 : 0
  alarm_name          = var.name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = coalesce(var.alarm_description, "${var.name} invocation error")
  actions_enabled     = true
  alarm_actions       = var.alarm_actions

  namespace   = "AWS/Lambda"
  metric_name = "Errors"
  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }
}

resource "aws_cloudwatch_log_subscription_filter" "lambda_logs_to_splunk" {
  count           = var.splunk_firehose_arn != null && var.splunk_firehose_role_arn != null ? 1 : 0
  name            = "${var.account}_${var.name}"
  log_group_name  = aws_cloudwatch_log_group.lambda.name
  filter_pattern  = "{ $.timestamp != \"\" }"
  destination_arn = var.splunk_firehose_arn
  role_arn        = var.splunk_firehose_role_arn
}

resource "aws_cloudwatch_event_rule" "keep_warm" {
  count               = var.keep_warm ? 1 : 0
  name                = "${var.name}-keep-warm"
  description         = "${var.name}-keep-warm"
  schedule_expression = var.keep_warm_schedule_expression
}

resource "aws_cloudwatch_event_target" "keep_warm" {
  count     = var.keep_warm ? 1 : 0
  rule      = aws_cloudwatch_event_rule.keep_warm[0].name
  target_id = aws_cloudwatch_event_rule.keep_warm[0].name
  arn       = aws_lambda_function.lambda.arn
  input     = "{\"__keep_warm__\": true}"
}

resource "aws_lambda_permission" "keep_warm" {
  count         = var.keep_warm ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.keep_warm[0].arn
}
