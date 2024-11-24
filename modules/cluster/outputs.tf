output "asg_name" {
  value       = aws_autoscaling_group.example.name
  description = "Auto Scaling group's name"
}

output "instance_security_group_id" {
  value       = aws_security_group.instance.id
  description = "EC2 Instance Security Group's ID"
}