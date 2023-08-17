output "arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.this.arn
}

output "target_group_arn" {
  description = "The ARN of the target group that was created"
  value       = aws_lb_target_group.this.arn
}

output "dns_name" {
  description = "The LB's DNS name"
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "The LB's zone id"
  value       = aws_lb.this.zone_id
}

output "listener_arn" {
  description = "The LB's listener ARN"
  value       = aws_lb_listener.this.arn
}
