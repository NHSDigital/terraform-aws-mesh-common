data "aws_dynamodb_table" "source" {
  name = var.source_table_name
}

data "aws_dynamodb_table" "target" {
  name = var.target_table_name
}

data "aws_lambda_function" "function" {
  function_name = var.lambda_function_arn
}

locals {
  source_table_arn = data.aws_dynamodb_table.source.arn
  target_table_arn = data.aws_dynamodb_table.target.arn
}
