
output "security_group_id" {
  description = "The security group id of the ALB"
  value       = aws_security_group.alb.id
}

output "arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.this.arn
}

output "listener_arn" {
  description = "The ARN of the ALB listener"
  value       = aws_alb_listener.this.arn
}

output "dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "The zone id of the ALB"
  value       = aws_lb.this.zone_id
}
