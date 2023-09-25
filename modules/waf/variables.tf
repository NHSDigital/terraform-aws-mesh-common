
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

variable "default_ip_rate_limit" {
  description = "default request limit per IP over 5m"
  type        = number
  default     = 100000
}

variable "unlimited_ip_rate_limit_ipv4_cidrs" {
  description = "v4 IPs with no rate limit"
  type        = list(string)
  default     = []
}

variable "unlimited_ip_rate_limit_ipv6_cidrs" {
  description = "v6 IPs with no rate limit"
  type        = list(string)
  default     = []
}

variable "specified_ip_rate_limit_ipv4_cidrs" {
  description = "v4 IPs with a specified rate limit"
  type = map(object({
    cidrs = list(string)
    limit = number
  }))
  default = {
    # e.g. 
    # nhsd = {
    #   cidrs = ["12.34.56.78/32", "23.45.67.89/64"]
    #   limit = 100000
    # },
    # other = {...}
  }
}

variable "specified_ip_rate_limit_ipv6_cidrs" {
  description = "v6 IPs with a specified rate limit"
  type = map(object({
    cidrs = list(string)
    limit = number
  }))
  default = {}
}
