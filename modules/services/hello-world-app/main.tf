provider "aws" {
  region = "us-east-2" # Specify the AWS region
}

terraform {
  # Use any Terraform version between 1.0.0 and 2.0.0
  required_version = ">= 1.0.0, < 2.0.0"

  # Require AWS provider version 4.x
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Module for Auto Scaling Group (ASG)
module "asg" {
  source = "../../cluster"

  # Setting up the cluster name with environment suffix
  cluster_name = "hello-world-${var.environment}"

  ami = var.ami # AMI ID for the instances
  instance_type = var.instance_type # Instance type (e.g., t2.micro)

  # User data script for EC2 instances
  user_data = templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    db_address  = local.mysql_config.address
    db_port     = local.mysql_config.port
    server_text = var.server_text
  })

  # ASG size configurations
  min_size = var.min_size
  max_size = var.max_size
  enable_autoscaling = var.enable_autoscaling

  # Networking and health check settings
  subnet_ids = local.subnet_ids
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB" # Using Elastic Load Balancer for health checks

  custom_tags = var.custom_tags # Adding custom tags
}

# Module for Application Load Balancer (ALB)
module "alb" {
  source = "../../networking"

  alb_name = "hello-world-${var.environment}" # Naming the ALB
  subnet_ids = local.subnet_ids # Subnets for the ALB
}

# Target group for the ASG
resource "aws_lb_target_group" "asg" {
  name = "hello-world-${var.environment}" # Target group name
  port = var.server_port # Target group port
  protocol = "HTTP" # Protocol used

  vpc_id = local.vpc_id # VPC where the target group is created

  # Health check configuration
  health_check {
    path = "/" # Health check path
    protocol = "HTTP" # Health check protocol
    matcher = "200" # Expecting 200 status for healthy
    interval = 15 # Time between health checks
    timeout = 3 # Health check timeout
    healthy_threshold = 2 # Mark as healthy after 2 successful checks
    unhealthy_threshold = 2 # Mark as unhealthy after 2 failures
  }
}

# Listener rule to forward traffic to the target group
resource "aws_lb_listener_rule" "asg" {
  listener_arn = module.alb.alb_http_listener_arn # ALB HTTP listener
  priority = 100 # Priority of this rule

  # Forward requests matching any path
  condition {
    path_pattern {
      values = ["*"] # Matches all paths
    }
  }

  action {
    type = "forward" # Forwarding traffic
    target_group_arn = aws_lb_target_group.asg.arn # Forward to this target group
  }
}
