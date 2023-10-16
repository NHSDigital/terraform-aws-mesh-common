
output "sg_id" {
  description = "The lambda function security group id"
  value       = module.lambda_function.sg_id
}

output "arn" {
  description = "The lambda function arn"
  value       = module.lambda_function.arn
}
