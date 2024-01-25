locals {
  prefix = lookup(var.logging, "prefix", null) == null ? null : trim(lookup(var.logging, "prefix"), "/")
}

resource "aws_s3_bucket_logging" "s3" {
  count         = local.prefix == null ? 0 : 1
  bucket        = var.bucket_name
  target_bucket = lookup(var.logging, "bucket", null)
  target_prefix = "${local.prefix}/"
}
