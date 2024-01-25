
locals {
  disallowed_encryption = var.encryption == "AES256" ? "aws:kms" : "AES256"
}

data "aws_iam_policy_document" "standard" {

  count = var.override_policy_json == null ? 1 : 0

  dynamic "statement" {
    for_each = var.encryption != null ? [1] : []
    content {

      sid    = "DenyIncorrectEncryptionHeader"
      effect = "Deny"

      principals {
        type        = "*"
        identifiers = ["*"]
      }

      actions = ["s3:PutObject"]
      resources = [
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
      condition {
        test = "StringEquals"
        values = [
          local.disallowed_encryption, ""
        ]
        variable = "s3:x-amz-server-side-encryption"
      }

    }
  }

  dynamic "statement" {
    for_each = var.acl != "public" ? [1] : []
    content {
      sid    = "DenyPublicReadACL"
      effect = "Deny"

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      actions = ["s3:PutObject", "s3:PutObjectAcl"]
      resources = [
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
      condition {
        test = "StringEquals"
        values = [
          "public-read",
          "public-read-write",
          "authenticated-read",
        ]
        variable = "s3:x-amz-acl"
      }
    }
  }

  dynamic "statement" {
    for_each = var.acl != "public" ? [1] : []
    content {
      sid    = "DenyPublicReadGrant"
      effect = "Deny"

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      actions = ["s3:PutObject", "s3:PutObjectAcl"]
      resources = [
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
      condition {
        test = "StringLike"
        values = [
          "*http://acs.amazonaws.com/groups/global/AllUsers*",
          "*http://acs.amazonaws.com/groups/global/AuthenticatedUsers*"
        ]
        variable = "s3:x-amz-grant-read"
      }
    }
  }

  dynamic "statement" {
    for_each = var.acl != "public" ? [1] : []
    content {
      sid    = "DenyPublicListACL"
      effect = "Deny"

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      actions = ["s3:PutBucketAcl"]
      resources = [
        "arn:aws:s3:::${var.bucket_name}"
      ]
      condition {
        test = "StringEquals"
        values = [
          "public-read",
          "public-read-write",
          "authenticated-read",
        ]
        variable = "s3:x-amz-acl"
      }
    }
  }

  dynamic "statement" {
    for_each = var.acl != "public" ? [1] : []
    content {
      sid    = "DenyPublicListGrant"
      effect = "Deny"

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      actions = ["s3:PutBucketAcl"]
      resources = [
        "arn:aws:s3:::${var.bucket_name}"
      ]
      condition {
        test = "StringLike"
        values = [
          "*http://acs.amazonaws.com/groups/global/AllUsers*",
          "*http://acs.amazonaws.com/groups/global/AuthenticatedUsers*"
        ]
        variable = "s3:x-amz-grant-read"
      }
    }
  }

  dynamic "statement" {
    for_each = var.kms_key_arn != null ? [1] : []
    content {
      sid    = "RequireSpecificKey"
      effect = "Deny"

      principals {
        type        = "*"
        identifiers = ["*"]
      }

      actions = ["s3:PutObject"]
      resources = [
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
      condition {
        test = "StringNotLike"
        values = [
          var.kms_key_arn, ""
        ]
        variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      }
    }
  }

  dynamic "statement" {
    for_each = var.require_ssl ? [1] : []
    content {
      sid    = "DenyNonSSLAccess"
      effect = "Deny"

      principals {
        type        = "*"
        identifiers = ["*"]
      }

      actions = ["s3:GetObject"]
      resources = [
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
      condition {
        test = "Bool"
        values = [
          "false"
        ]
        variable = "aws:SecureTransport"
      }
    }
  }

}

data "aws_iam_policy_document" "policy" {

  count = var.override_policy_json == null ? 1 : 0

  source_policy_documents = concat(
    [data.aws_iam_policy_document.standard[0].json],
    var.policy_json == null ? [] : [var.policy_json]
  )
}


resource "aws_s3_bucket_policy" "s3" {
  bucket = var.bucket_name
  policy = coalesce(var.override_policy_json, data.aws_iam_policy_document.policy[0].json)
}
