variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
  default     = "s3-state-bucket-ssk"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "terraform_locks_table_ssk"
}
