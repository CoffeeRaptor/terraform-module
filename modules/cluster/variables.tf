# Required
variable "cluster_name" {
  description = "Name for all resources in the cluster"
  type        = string
}

variable "ami" {
  description = "AMI ID to launch in the cluster"
  type        = string
}

variable "instance_type" {
  description = "Specify the instance type (e.g., t2.micro)"
  type        = string

  validation {
    condition = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Only free-tier instance types are allowed: t2.micro or t3.micro."
  }
}

variable "min_size" {
  description = "Minimum number of EC2 instances in the ASG"
  type        = number

  validation {
    condition     = var.min_size > 0
    error_message = "ASGs must have at least one instance to prevent outages!"
  }

  validation {
    condition     = var.min_size <= 10
    error_message = "Keep the ASG size under 10 instances to manage costs effectively."
  }
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the ASG"
  type        = number

  validation {
    condition     = var.max_size > 0
    error_message = "ASGs must have at least one instance to prevent outages!"
  }

  validation {
    condition     = var.max_size <= 10
    error_message = "Limit the ASG to 10 or fewer instances for cost efficiency."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs to deploy instances in"
  type = list(string)
}

variable "enable_autoscaling" {
  description = "Set to true to turn on auto scaling"
  type        = bool
}

# Optional
variable "target_group_arns" {
  description = "List of load balancer target group ARNs for registering instances"
  type = list(string)
  default = []
}

variable "health_check_type" {
  description = "Health check type (choose between EC2 or ELB)"
  type        = string
  default     = "EC2"

  validation {
    condition = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "Health check type must be either EC2 or ELB."
  }
}

variable "user_data" {
  description = "Script to run when instances start up"
  type        = string
  default     = null
}

variable "custom_tags" {
  description = "Add custom tags for instances in the ASG"
  type = map(string)
  default = {}
}

variable "server_port" {
  description = "Port for HTTP requests handled by the server"
  type        = number
  default     = 8080
}