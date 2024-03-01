
variable "account" {
  description = "The account"
  type        = string
  validation {
    condition     = contains(["local", "dev", "nonprod", "prod"], var.account)
    error_message = "Valid values for var: account are (local, dev, nonprod, prod)."
  }
}

variable "vpc_id" {
  description = "The VPC id for the vpc in which the lambda will reside"
  type        = string
}

variable "logs_vpc_endpoint_sg_id" {
  description = "The security group id for the cloudwatch logs vpc endpoint"
  type        = string
}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "aws region name"
}

variable "name" {
  description = "Lambda function name"
  type        = string
}

variable "file_path" {
  description = "The file path to the zipped source code for the lambda function"
  type        = string
}

variable "handler" {
  description = "Function entrypoint in your code."
  type        = string
  default     = "function.handler"
}

variable "runtime" {
  description = "Identifier of the function's runtime. See https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime"
  type        = string
  default     = "python3.11"
}

variable "environment" {
  description = "Environment variables for the lambda function"
  type        = map(string)
  default     = {}
}

variable "subnet_ids" {
  description = "The list of subnet ids in which this lambda will run"
  type        = list(string)
}

variable "role_json" {
  description = "IAM policy document json to attach to the lambda"
  type        = string
  default     = null
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function"
  type        = list(string)
  default     = []
}

variable "alarm_actions" {
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN)."
  type        = list(string)
  default     = []
}

variable "timeout" {
  description = "Amount of time your Lambda Function has to run in seconds. Defaults to 3. Max 900 (15 mins)"
  type        = number
  default     = 3
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  type        = number
  default     = 128
}

variable "alarm_description" {
  description = "The description for the cloudwatch metric alarm."
  type        = string
  default     = null
}

variable "splunk_firehose_arn" {
  description = "Destination arn for the cloudwatch log subscription filter"
  type        = string
  default     = null
}

variable "splunk_firehose_role_arn" {
  description = "The role ARN for the cloudwatch log subscription filter"
  type        = string
  default     = null
}

variable "deadletter_queue_arn" {
  description = "ARN of an SQS queue to notify when an invocation fails"
  type        = string
  default     = null
}

variable "deadletter_max_retries" {
  description = "Maximum number of times to retry when the function returns an error. Valid values between 0 and 2. Defaults to 2."
  type        = number
  default     = 2
}

variable "deadletter_max_age_seconds" {
  description = "Maximum age of a request that Lambda sends to a function for processing in seconds. Valid values between 60 and 21600."
  type        = number
  default     = 21600
}

variable "keep_warm" {
  description = "will send {\"__keep_warm__\": true} requests on keep_warm_schedule_expression"
  type        = bool
  default     = false
}

variable "keep_warm_schedule_expression" {
  description = "keep warm cloudwatch event schedule .. either cron(...) or  rate(..)"
  type        = string
  default     = "rate(4 minutes)"
}

variable "log_delivery_destinations" {
  description = <<EOT
    log_delivery_destinations = {
      name: {
        destination_arn : "aws_cloudwatch_log_subscription_filter destination arn"
        role_arn: "aws_cloudwatch_log_subscription_filter role arn"
        filter_pattern: "log filter pattern default `{ $.timestamp != \"\" }`"
      }
    }
  EOT
  type = map(
    object({
      destination_arn : string,
      role_arn : string,
      filter_pattern : optional(string)
    })
  )
  default = {}
}
