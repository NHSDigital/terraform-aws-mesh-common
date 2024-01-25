
resource "aws_s3_bucket_versioning" "s3" {
  count  = var.versioning == null ? 0 : 1
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = var.versioning == true ? "Enabled" : "Suspended" # tfsec:ignore:aws-s3-enable-versioning
  }
}
