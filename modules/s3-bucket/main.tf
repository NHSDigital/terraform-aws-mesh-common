
# not true these are created as separate resources
#tfsec:ignore:aws-s3-enable-bucket-encryption
#tfsec:ignore:aws-s3-encryption-customer-key
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }

  lifecycle {
    ignore_changes = [
      logging, lifecycle_rule, server_side_encryption_configuration, replication_configuration, grant
    ]
  }

}
