variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
  default     = null
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
  default     = null
}
#optional
variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = null
}

variable "backup_retention_preiod" {
  description = "Days to retain backups and value should be higher than 0 to enable replication"
  type        = number
  default     = null
}

variable "replicate_source_db" {
  description = "If specified, replicate the RDS database for the given RDS ARN"
  type        = string
  default     = null
}
