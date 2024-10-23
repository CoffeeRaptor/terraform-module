variable "db_username" {
  description = "The username of the database"
  type        = string
  sensitive   = true
  default = "ssk"
}

variable "db_password" {
  description = "The password of the database"
  type        = string
  sensitive   = true
}
#optional
variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "example_database_prod"
}
