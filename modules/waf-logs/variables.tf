variable "app_name" {
  description = "The application name. Used for naming and prefixing"
  type        = string
}

variable "web_acl_arn" {
  description = "The ARN of the WAFv2 WebACL"
  type        = string
}

variable "filter_pattern" {
  description = "The subscription filter pattern"
  type        = string
  default     = ""
}

variable "log_destination_arn" {
  description = "ARN for the log subscription filter to send logs to (optional)"
  type        = string
  default     = null
}

variable "region" {
  description = "The region where the logs are stored"
  type        = string
  default     = "eu-west-2"
}
