variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
  default = "ssk"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}
#optional
variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "example_database_stage"
}
