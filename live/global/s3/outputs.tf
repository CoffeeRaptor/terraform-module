output "s3_bucket_arn" {
  value       = aws_s3_bucket.state_storage.arn
  description = "S3 bucket ARN"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_state_locks.name
  description = "Name of the DynamoDB table"
}
