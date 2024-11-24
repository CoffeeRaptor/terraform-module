terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  # Specifying the AWS provider version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Creating an Application Load Balancer (ALB)
resource "aws_lb" "example" {
  name               = var.alb_name
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups = [aws_security_group.alb.id]
}

# Listener for the ALB on HTTP port
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = local.http_port
  protocol          = "HTTP"

  # Default action for unmatched requests: return a simple 404 response
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

# Security group for the ALB
resource "aws_security_group" "alb" {
  name = var.alb_name
}

# Allow inbound HTTP traffic
resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips # Open to the internet (be cautious!)
}

# Allow all outbound traffic (needed for instances to communicate outside)
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}

# Local variables for reusability and clarity
locals {
  http_port = 80          # HTTP default port
  any_port = 0           # Represents all ports
  any_protocol = "-1"        # Represents all protocols
  tcp_protocol = "tcp"       # Specifically for TCP traffic
  all_ips = ["0.0.0.0/0"] # Publicly accessible, use carefully!
}