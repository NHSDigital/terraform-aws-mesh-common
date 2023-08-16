variable "name_prefix" {
  description = "Prefix for the shield protection name"
  type        = string
}

variable "arns_to_protect" {
  description = "Map of name to arn to be protected with shield"
  type        = map(string)
  default     = {}
}
