
output "bucket" {
  description = "created s3 bucket name"
  value       = aws_s3_bucket.s3.bucket
}

output "arn" {
  description = "created s3 bucket arn"
  value       = aws_s3_bucket.s3.arn
}
