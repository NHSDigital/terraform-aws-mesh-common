locals {

  current_expirations = [for k, v in lookup(var.lifecycle_configuration, "transition_days", {}) : v if k == "expire"]
  current_transitions = { for k, v in lookup(var.lifecycle_configuration, "transition_days", {}) : k => v if k != "expire" }

  noncurrent_expirations = [for k, v in lookup(var.lifecycle_configuration, "noncurrent_transition_days", {}) : v if k == "expire"]
  noncurrent_transitions = { for k, v in lookup(var.lifecycle_configuration, "noncurrent_transition_days", {}) : k => v if k != "expire" }

}


resource "aws_s3_bucket_lifecycle_configuration" "s3" {
  bucket = aws_s3_bucket.s3.id

  depends_on = [
    aws_s3_bucket_versioning.s3
  ]

  rule {
    id     = "${aws_s3_bucket.s3.bucket}-transition-rule"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = var.abort_incomplete_multipart_upload_days
    }

    filter {}
    dynamic "expiration" {
      for_each = local.current_expirations
      content {
        days = expiration.value
      }
    }
    dynamic "transition" {
      for_each = local.current_transitions
      content {
        days          = transition.value
        storage_class = upper(transition.key)
      }
    }

  }

  rule {
    id     = "${aws_s3_bucket.s3.bucket}-noncurrent-transition-rule"
    status = "Enabled"

    dynamic "expiration" {
      for_each = var.expired_object_delete_marker ? [1] : []
      content {
        expired_object_delete_marker = true
      }
    }

    filter {}
    dynamic "noncurrent_version_expiration" {
      for_each = local.noncurrent_expirations
      content {
        noncurrent_days = noncurrent_version_expiration.value
      }
    }
    dynamic "noncurrent_version_transition" {
      for_each = local.noncurrent_transitions
      content {
        noncurrent_days = noncurrent_version_transition.value
        storage_class   = upper(noncurrent_version_transition.key)
      }
    }

  }

}
