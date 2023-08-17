variable "app_name" {
  description = "The application name. Used for naming and prefixing"
  type        = string
}

variable "account_vpc_id" {
  description = "The account's vpc id"
  type        = string
}

variable "target_healthcheck_path" {
  description = "The healthcheck path for the target"
  type        = string
}

variable "envs" {
  description = "List of all environment in this account - for indexing rules"
  type        = list(string)
}

variable "env" {
  description = "The environment for this rule"
  type        = string
}

variable "target_port" {
  description = "The target group's port"
  type        = number
}

variable "private_alb_arn" {
  description = "The ARN of the private application load balancer that this rule is to be attached"
  type        = string
}

variable "public_nlb_dns_name" {
  description = "The DNS name of the public NLB"
  type        = string
}

variable "public_nlb_zone_id" {
  description = "The zone id of the public NLB"
  type        = string
}

variable "dns_domain" {
  description = "The DNS name for the A record and certificate"
  type        = string
}

variable "base_dns_name" {
  description = "The dns name of the zone in which the A record will be created"
  type        = string
}

variable "host_header_values" {
  description = "The host header values for this rule, e.g. ui.*, ui.int.*"
  type        = list(string)
}

variable "two_char_prefix" {
  description = "The 2 character unique value for the name prefix for the target group"
  type        = string
}
