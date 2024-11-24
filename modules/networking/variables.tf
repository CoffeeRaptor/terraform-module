# Required
variable "alb_name" {
  description = "ALB's name"
  type        = string
}

variable "subnet_ids" {
  description = "ID of the subnets to use"
  type = list(string)
}