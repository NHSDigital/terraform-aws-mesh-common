variable "app_name" {
  description = "The application name. Used for naming and prefixing"
  type        = string
}

variable "account_vpc_id" {
  description = "The account's vpc id"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of the private subnet ids for this load balancer"
  type        = list(string)
}

variable "traffic_port" {
  description = "The incoming traffic port"
  type        = number
}

variable "alb_healthcheck_path" {
  description = "The healthcheck path for the ALB"
  type        = string
  default     = "/"
}

variable "access_logs_bucket" {
  description = "The bucket in which the ALB's logs are stored"
  type        = string
}

variable "dummy_certificate_arn" {
  description = "The ARN of the dummy certificate on the main ALB listener"
  type        = string
}
