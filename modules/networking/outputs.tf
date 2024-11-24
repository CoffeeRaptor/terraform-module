output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "DNS name of the ALB so I can access it"
}

output "alb_http_listener_arn" {
  value       = aws_lb_listener.http.arn
  description = "ARN for the HTTP listener on the ALB"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "Security Group ID used by the ALB"
}
