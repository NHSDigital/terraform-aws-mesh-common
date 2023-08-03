
output "sg_id" {
  description = "The lambda's security goup id"
  value       = aws_security_group.lambda.id
}

output "name" {
  description = "The name of the lambda"
  value       = aws_lambda_function.lambda.function_name
}

output "arn" {
  description = "The lambda's ARN"
  value       = aws_lambda_function.lambda.arn
}

output "log_group_name" {
  description = "The cloudwatch log group that the lambda is logging to."
  value       = aws_cloudwatch_log_group.lambda.name
}

output "execution_role" {
  description = "The IAM role ARN and name that the lambda is executing with."
  value = {
    arn  = aws_iam_role.lambda.arn
    name = aws_iam_role.lambda.name
  }
}
