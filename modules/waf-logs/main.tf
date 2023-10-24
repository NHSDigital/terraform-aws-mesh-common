resource "aws_iam_role" "this" {
  name = "${var.app_name}-CWLtoSubscriptionFilterRole"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Action = "sts:AssumeRole",
          Principal = {
            Service = "logs.${var.region}.amazonaws.com"
          },
          Effect = "Allow"
        }
      ]
    }
  )
}

resource "aws_cloudwatch_log_group" "this" {
  # Must have a "aws-waf-logs-" prefix
  # See https://docs.aws.amazon.com/waf/latest/developerguide/logging-management.html
  name              = "aws-waf-logs-waf/${var.app_name}"
  retention_in_days = 90
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.app_name}-Permissions-Policy-For-CWL-Subscription-filter"
  policy = data.aws_iam_policy_document.this.json
  role   = aws_iam_role.this.id
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.this.arn}:*"
    ]
  }
}

resource "aws_cloudwatch_log_subscription_filter" "this" {
  count = var.log_destination_arn == null ? 0 : 1

  name            = "${var.app_name}_waf_logs"
  log_group_name  = aws_cloudwatch_log_group.this.name
  filter_pattern  = var.filter_pattern
  destination_arn = var.log_destination_arn
  role_arn        = aws_iam_role.this.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  log_destination_configs = [
    aws_cloudwatch_log_group.this.arn
  ]
  resource_arn = var.web_acl_arn
}
