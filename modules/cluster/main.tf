terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  # Specifying the required AWS provider version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Launch configuration for EC2 instances
resource "aws_launch_configuration" "example" {
  image_id      = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.instance.id] # Security group for the instances
  user_data     = var.user_data # User data script for the instances

  lifecycle {
    create_before_destroy = true # To avoid downtime during updates
  }
}

# Auto Scaling Group for managing EC2 instances
resource "aws_autoscaling_group" "example" {
  name                 = var.cluster_name
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = var.subnet_ids # Deploying into these subnets

  # Configuring load balancer
  target_group_arns = var.target_group_arns
  health_check_type = var.health_check_type

  min_size = var.min_size
  max_size = var.max_size

  # Rolling updates for instances
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50 # Ensuring at least 50% of instances are healthy
    }
  }

  # Tag for naming resources
  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  # Adding custom tags dynamically
  dynamic "tag" {
    for_each = {
      for key, value in var.custom_tags :
      key => upper(value)
      if key != "Name"
    }

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# Scaling schedule to increase capacity during business hours
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence = "0 9 * * *" # At 9 AM daily
  autoscaling_group_name = aws_autoscaling_group.example.name
}

# Scaling schedule to decrease capacity at night
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence = "0 17 * * *" # At 5 PM daily
  autoscaling_group_name = aws_autoscaling_group.example.name
}

# Security group for the instances
resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"
}

# Allow inbound traffic to the server port
resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = var.server_port
  to_port     = var.server_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips # Open to all IPs (be cautious)
}

# CloudWatch alarm for high CPU usage
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name  = "${var.cluster_name}-high-cpu-utilization"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period = 300 # 5-minute period
  statistic           = "Average"
  threshold = 90 # Trigger if CPU utilization exceeds 90%
  unit                = "Percent"
}

# CloudWatch alarm for low CPU credit balance (only for burstable instances)
resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = format("%.1s", var.instance_type) == "t" ? 1 : 0 # Only for t-series instances

  alarm_name  = "${var.cluster_name}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period = 300 # 5-minute period
  statistic           = "Minimum"
  threshold = 10 # Trigger if CPU credits drop below 10
  unit                = "Count"
}

# Local variables for reusable values
locals {
  tcp_protocol = "tcp"        # Protocol for inbound traffic
  all_ips = ["0.0.0.0/0"] # Open to all (use carefully!)
}
