
variable "app_name" {
  description = "Application name"
  type        = string
}

variable "alb_arn" {
  description = "The ARN of the application load balancer with which to associate the WAF"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR for the VPC to allow healthchecking from an NLB"
  type        = string
}

variable "blocked_ipv4_cidrs" {
  description = "List of IPv4 CIDRs to block"
  type        = list(string)
  default     = []
}

variable "blocked_ipv6_cidrs" {
  description = "List of IPv6 CIDRs to block"
  type        = list(string)
  default     = []
}

variable "allowed_ipv4_cidrs" {
  description = "List of IPv4 CIDRs to allow"
  type        = list(string)
  default     = []
}

variable "allowed_ipv6_cidrs" {
  description = "List of IPv6 CIDRs to allow"
  type        = list(string)
  default     = []
}

variable "managed_rules" {
  description = "List of managed rules to apply"
  type        = list(string)
  default = [
    "AWSManagedRulesCommonRuleSet"
  ]
}

variable "allowed_country_codes" {
  description = "List of allowed country codes"
  type        = list(string)
  default = [
    "GB"
  ]
}

variable "ip_rate_limit" {
  description = "Request limit per IP over 5m"
  type        = number
  default     = 5000
}
