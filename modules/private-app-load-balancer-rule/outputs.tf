output "alb_target_group_arn" {
  description = "The ARN of the target group that was created for this rule"
  value       = aws_lb_target_group.this.arn
}

output "fqdn" {
  description = "The fully qualified domain name route 53 record that was created for this endpoint"
  value       = aws_route53_record.this.fqdn
}
