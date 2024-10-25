output "address" {
  value       = aws_db_instance.example.address
  description = "Connect to the database at this address"
}

output "port" {
  value       = aws_db_instance.example.port
  description = "The listening port of the database"
}

output "arn" {
  value       = aws_db_instance.example.arn
  description = "The ARN of the database"
}