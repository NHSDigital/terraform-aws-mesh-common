variable "source_table_name" {
  description = "The source dynamodb table name"
  type        = string
}

variable "source_table_kms_arn" {
  description = "The source dynamodb table name kms key arn"
  type        = string
}

variable "target_table_name" {
  description = "The target dynamodb table name"
  type        = string
}

variable "target_table_kms_arn" {
  description = "The target dynamodb table name kms key arn"
  type        = string
}

variable "lambda_function_arn" {
  description = "The ARN of the lambda function that processes the stream"
  type        = string
}

variable "lambda_sg_id" {
  description = "Security group id for the lambda function"
  type        = string
}

variable "dynamodb_gateway_prefix_list_ids" {
  description = "The prefix list ids for the DDB gateway"
  type        = string
}

variable "lambda_role_name" {
  description = "The role name for the lambda"
  type        = string
}

variable "event_source_mapping_batch_size" {
  description = "The event source mapping batch size"
  type        = number
  default     = 100
}

variable "event_source_mapping_bisect" {
  description = "The event source bisect batch on function error flag"
  type        = bool
  default     = true
}

variable "event_source_mapping_parallelization_factor" {
  description = "The event source parallelization factor"
  type        = number
  default     = 5
}

variable "event_source_mapping_max_batch_window_secs" {
  description = "The event source maximum batching window in seconds"
  type        = number
  default     = 1
}

variable "event_source_mapping_starting_position" {
  description = "The event source mapping starting position"
  type        = string
  default     = "LATEST"
}

variable "event_source_mapping_enabled" {
  description = "The event source mapping enabled flag"
  type        = bool
  default     = true
}
