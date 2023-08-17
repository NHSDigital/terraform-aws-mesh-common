variable "app_name" {
  description = "The application name. Used for naming and prefixing"
  type        = string
}

variable "account_vpc_id" {
  description = "The account's vpc id"
  type        = string
}

variable "account" {
  description = "The name of the account"
  type        = string
  validation {
    condition     = contains(["local", "dev", "nonprod", "prod"], var.account)
    error_message = "Valid values for var: account are (local, dev, nonprod, prod)."
  }
}

variable "public_subnet_ids" {
  description = "A list of the public subnet ids for this load balancer"
  type        = list(string)
}

variable "alb_healthcheck_path" {
  description = "The healthcheck path for the ALB"
  type        = string
}

variable "traffic_port" {
  description = "The incoming traffic port"
  type        = number
}

variable "two_char_prefix" {
  description = "The 2 character unique value for the name prefix for the target group for this app"
  type        = string
}

variable "access_logs_bucket" {
  description = "The bucket in which the LB's logs are stored"
  type        = string
}
