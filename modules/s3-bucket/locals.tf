locals {
  encryption = coalesce(var.encryption, var.kms_key_arn == null ? "AES256" : "aws:kms")
}
