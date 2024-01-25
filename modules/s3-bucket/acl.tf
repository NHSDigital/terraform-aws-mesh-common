
resource "aws_s3_bucket_acl" "s3" {
  count  = var.acl == "private" ? 0 : 1
  acl    = var.acl
  bucket = aws_s3_bucket.s3.id
}

resource "aws_s3_bucket_ownership_controls" "acls" {
  bucket = aws_s3_bucket.s3.id
  rule {
    object_ownership = var.acl == "private" ? "BucketOwnerEnforced" : "BucketOwnerPreferred"
  }
}
