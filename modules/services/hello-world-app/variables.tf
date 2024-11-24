# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These are the parameters you need to provide for the setup to work.
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "Name of the environment we’re deploying to (e.g., dev, prod)"
  type        = string
}

variable "min_size" {
  description = "Minimum number of EC2 instances for the Auto Scaling Group"
  type        = number
}

variable "max_size" {
  description = "Maximum number of EC2 instances for the Auto Scaling Group"
  type        = number
}

variable "enable_autoscaling" {
  description = "Set to true if auto scaling should be enabled"
  type        = bool
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have defaults, so you can skip them if you’re okay with the defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "ami" {
  description = "AMI ID for the instances in the cluster"
  type        = string
}

variable "instance_type" {
  description = "Instance type to use (e.g., t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "server_text" {
  description = "Text the server should display when accessed"
  default     = "Hello, World"
  type        = string
}

variable "server_port" {
  description = "Port the server will use for handling HTTP requests"
  type        = number
  default     = 8080
}

variable "custom_tags" {
  description = "Custom tags to add to the EC2 instances in the ASG"
  type = map(string)
  default = {}
}

variable "db_remote_state_bucket" {
  description = "S3 bucket name where the DB's Terraform state is stored"
  type        = string
  default     = null
}

variable "db_remote_state_key" {
  description = "Path to the DB's Terraform state file in the S3 bucket"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC to deploy resources into"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs to use for deployment"
  type = list(string)
  default     = null
}

variable "mysql_config" {
  description = "Configuration for the MySQL database (address and port)"
  type = object({
    address = string
    port    = number
  })
  default = null
}