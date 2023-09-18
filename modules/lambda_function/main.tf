# tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "lambda" {
  filename = var.file_path

  function_name    = var.name
  role             = aws_iam_role.lambda.arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = filebase64sha256(var.file_path)
  # Check https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Lambda-Insights-extension-versionsx86-64.html for updates
  layers      = var.account == "local" ? [] : concat(var.layers, ["arn:aws:lambda:${var.region}:580247275435:layer:LambdaInsightsExtension:21"])
  timeout     = var.timeout
  memory_size = var.memory_size

  dynamic "environment" {
    for_each = length(var.environment) > 0 ? [1] : []
    content {
      variables = var.environment
    }
  }

  vpc_config {
    security_group_ids = [
      aws_security_group.lambda.id
    ]
    subnet_ids = var.subnet_ids
  }

}


resource "aws_lambda_function_event_invoke_config" "deadletter" {
  # async invocations use a secret queue

  count = var.deadletter_queue_arn == null ? 0 : 1

  function_name                = aws_lambda_function.lambda.function_name
  maximum_event_age_in_seconds = var.deadletter_max_age_seconds
  maximum_retry_attempts       = var.deadletter_max_retries

  destination_config {
    on_failure {
      destination = var.deadletter_queue_arn
    }
  }
}
