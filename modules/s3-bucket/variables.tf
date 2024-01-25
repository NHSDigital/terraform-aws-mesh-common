variable "bucket_name" {
  type        = string
  description = "The name of the s3 bucket."
}

variable "acl" {
  type        = string
  default     = "private"
  description = "bucket acl private/log-delivery-write/public, default=private"
  validation {
    condition     = contains(["private", "log-delivery-write", "public"], var.acl)
    error_message = "Variable 'acl' must be one of: private, log-delivery-write, public."
  }
}

variable "policy_json" {
  type        = string
  default     = null
  description = "s3 extensions to the s3 bucket policy json"
}

variable "override_policy_json" {
  type        = string
  default     = null
  description = "this will totally override the the policy and not create 'standard' bucket policy"
}

variable "require_ssl" {
  description = "if true denies non SSL access only set to false if you have public objects and allow http access"
  type        = bool
  default     = true
}

variable "encryption" {
  type        = string
  default     = "aws:kms"
  description = "default bucket encryption null/AES256/aws:kms, default=aws:kms (requires kms_key_arn)"
  validation {
    condition     = var.encryption == null || var.encryption == "AES256" || var.encryption == "aws:kms"
    error_message = "Variable encryption must be null, AES256 or aws:kms  (default aws:kms)."
  }
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "arn of the kms for for kms encryption."
}

variable "abort_incomplete_multipart_upload_days" {
  description = "number of days after which to automatically abort multipart uploads, default=2"
  type        = number
  default     = 2
}

variable "expired_object_delete_marker" {
  description = "create a delete marker for expired objects"
  type        = bool
  default     = true
}

variable "lifecycle_configuration" {
  description = "Rules governing when to switch between s3 storage classes/expires. Note that noncurrent transition rules are ignored when var.versioning is false."
  type        = map(map(number))
  default = {
  }
  validation {
    condition     = length(var.lifecycle_configuration) == 0 || length(setsubtract(keys(var.lifecycle_configuration), ["transition_days", "noncurrent_transition_days"])) == 0
    error_message = "Variable lifecycle_configuration may contain only 'transition_days' and 'noncurrent_transition_days'."
  }

  validation {
    # This checks that both map(number): transition_days & noncurrent_transition_days only contain the desired keys.
    condition = length(
      flatten(
        [
          for key in ["transition_days", "noncurrent_transition_days"] :
          setsubtract(
            keys(lookup(var.lifecycle_configuration, key, {})),
            ["standard_ia", "intelligent_tiering", "onezone_ia", "glacier_ir", "glacier", "deep_archive", "expire"]
          )
        ]
      )
    ) == 0
    error_message = "Unexpected key in map lifecycle_configuration['transition_days'] or lifecycle_configuration['noncurrent_transition_days']."
  }
}


variable "versioning" {
  type        = bool
  default     = null
  description = "Pass enabled=true/false to create a versioning object. Pass null to omit creating a versioning resource."
}

variable "logging" {
  type        = map(string)
  default     = {}
  description = "Log requests that access this s3 bucket in another s3 bucket, potentially with an athena database. The prefix is used to distinguish entries in both the bucket and the athena database."

  validation {
    condition     = length(setsubtract(keys(var.logging), ["prefix", "bucket"])) == 0
    error_message = "Variable logging may contain only 'prefix' and 'bucket_name'."
  }

  validation {
    condition = (
      (lookup(var.logging, "prefix", null) != null && lookup(var.logging, "bucket", null) != null) ||
      (lookup(var.logging, "prefix", null) == null && lookup(var.logging, "bucket", null) == null)
    )
    error_message = "Variable logging requires values for keys 'prefix' and 'bucket' both be null, or neither be null."
  }

  validation {
    condition     = length(regexall("^[-a-z0-9_]+$", coalesce(lookup(var.logging, "prefix"), "dummy-value-in-case-prefix-is-null"))) == 1
    error_message = "Variable logging['prefix'] must be all alpha/numeric lowercase and hyphens."
  }
}
