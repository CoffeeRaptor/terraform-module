output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the load balancer to access it"
}

output "asg_name" {
  value       = module.asg.asg_name
  description = "Name of the Auto Scaling Group"
}

output "instance_security_group_id" {
  value       = module.asg.instance_security_group_id
  description = "Security Group ID for the EC2 instances"
}
