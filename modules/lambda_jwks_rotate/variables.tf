variable "name" {
  description = "Lambda function name"
  type        = string
}

variable "account" {
  description = "The account"
  type        = string
  validation {
    condition     = contains(["local", "dev", "nonprod", "prod"], var.account)
    error_message = "Valid values for var: account are (local, dev, nonprod, prod)."
  }
}

variable "account_vpc" {
  description = "account vpc composite object"
  type = object({
    id = string
    subnet = object({
      private = map(object({
        id = string
      }))
    })
    interface-endpoint-sg-ids = map(string)
    gateway-prefix-list-ids   = map(string)
  })
}

variable "env" {
  description = "The environment name"
  type        = string
}

variable "zip_output_path" {
  description = "The relative path to output the lambda function zip file"
  type        = string
  default     = "../../../lambda/dist/jwks_rotate.zip"
}

variable "lambda_layers" {
  description = "The lambda layers"
  type        = list(string)
  default     = []
}
variable "lambda_alarm_actions" {
  description = "The lambda alarm actions"
  type        = list(string)
  default     = []
}

variable "base_secrets_arn" {
  description = "base arn for secrets"
  type        = string
}

variable "jwks_certs_secrets_id_prefix" {
  description = "secret id prefix for public/private jwks keys"
  type        = string
}

variable "jwks_certs_secrets_kms_key_id" {
  description = "kms key id to use for jwks certs secrets"
  type        = string
}

variable "jwks_certs_secrets_kms_key_arn" {
  description = "kms key arn to use for jwks certs secrets"
  type        = string
}

variable "jwks_current_kid_ssm_arn" {
  description = "ssm param name arn for current kid"
  type        = string
}

variable "jwks_current_kid_ssm_name" {
  description = "ssm param name for current kid"
  type        = string
}

variable "jwks_json_s3_kms_arn" {
  description = "s3 kms arn for jwks json file"
  type        = string
}

variable "jwks_json_s3_bucket_arn" {
  description = "s3 bucket arn for jwks json file"
  type        = string
}

variable "jwks_json_s3_bucket_name" {
  description = "s3 bucket name for jwks json file"
  type        = string
}

variable "jwks_json_s3_key" {
  description = "s3 key for jwks json file"
  type        = string
}

variable "jwks_min_keys_retained" {
  description = "total number of keys to keep"
  type        = number
  validation {
    condition     = var.jwks_min_keys_retained > 1
    error_message = "Value must be greater than 1."
  }
}

variable "jwks_min_days_retained" {
  description = "minimum no of days to keep keys (regardless of jwks_min_keys_retained)"
  type        = number
  default     = 30
  validation {
    condition     = var.jwks_min_days_retained > 6
    error_message = "Value must be greater than 6."
  }
}

variable "jwks_schedule_expression" {
  description = "chron schedule expression for triggering the lambda"
  type        = string
  default     = "cron(0 10 ? * 2#1 *)"
}

variable "boto_env_vars" {
  description = "boto env vars, e.g. BOTO_RETRIES_MODE"
  type        = map(string)
  default     = {}
}
