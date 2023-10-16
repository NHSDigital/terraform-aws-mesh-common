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

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "aws region name"
}

variable "vpc_id" {
  description = "The VPC id for the vpc in which the lambda will reside"
  type        = string
}

variable "logs_vpc_endpoint_sg_id" {
  description = "The security group id for the cloudwatch logs vpc endpoint"
  type        = string
}

variable "secrets_manager_interface_endpoint_sg_ids" {
  description = "The security group ids for the secrets manager interface endpoint"
  type        = string
}

variable "ssm_interface_endpoint_sg_ids" {
  description = "The security group ids for the ssm interface endpoint"
  type        = string
}

variable "s3_gateway_prefix_list_ids" {
  description = "The prefix list ids for the s3 gateway"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet ids in which this lambda will run"
  type        = list(string)
}

variable "env" {
  description = "The environment name"
  type        = string
}

variable "file_path" {
  description = "The relative file path to the zipped source code for the lambda function"
  type        = string
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

variable "lambda_alarm_description" {
  description = "alarm description for lambda failure"
  type        = string
}

variable "lambda_timeout" {
  description = "lamdba timeout in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "lamdba memory size in MB"
  type        = number
  default     = 128
}

variable "lambda_runtime" {
  description = "Identifier of the function's runtime. See https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime"
  type        = string
  default     = "python3.11"
}
