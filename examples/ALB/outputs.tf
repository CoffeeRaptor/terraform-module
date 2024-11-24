output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "Load balancer's domain name"
}