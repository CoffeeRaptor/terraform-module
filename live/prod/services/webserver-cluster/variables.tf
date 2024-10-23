variable "db_remote_state_bucket" {
  description = "s3 bucket name to store the remote state file in the backend"
  type        = string
  default="s3-state-bucket-ssk"
}

variable "db_remote_state_key" {
  description = "TThe path for the database's remote state in the s3 bucket"
  type        = string
  default="live/prod/data-stores/mysql/terraform.tfstate"
}
#optional
variable "cluster_name" {
  description = "name to be used for all cluster resources"
  type        = string
  default     = "webservers-prod"
}

variable "enable_autoscaling" {
  description = "If set to true, autoscaling is enabled"
  type = bool
}
