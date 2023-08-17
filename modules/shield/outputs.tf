output "shield_protection_arns" {
  description = "The ARNs of the shield protection"
  value = {
    for k, sp in aws_shield_protection.this : k => sp.arn
  }
}
