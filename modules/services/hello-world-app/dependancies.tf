# Fetch remote state for the MySQL database if mysql_config is not provided
data "terraform_remote_state" "db" {
  count = var.mysql_config == null ? 1 : 0 # Only fetch if mysql_config is null

  backend = "s3" # Remote state stored in S3

  config = {
    bucket = var.db_remote_state_bucket # S3 bucket for the remote state
    key = var.db_remote_state_key    # Key (file path) in the S3 bucket
    region = "us-east-2"                # Region where the S3 bucket is located
  }
}

# Fetch the default VPC if no specific VPC ID is provided
data "aws_vpc" "default" {
  count = var.vpc_id == null ? 1 : 0 # Only fetch if vpc_id is null
  default = true # Fetch the default VPC in the account
}

# Fetch default subnets if no specific subnet IDs are provided
data "aws_subnets" "default" {
  count = var.subnet_ids == null ? 1 : 0 # Only fetch if subnet_ids is null

  filter {
    name = "vpc-id" # Filter subnets by VPC ID
    values = [local.vpc_id] # Use the determined VPC ID
  }
}

# Local variables for configuration values
locals {
  # Use mysql_config from var if provided, otherwise fetch it from remote state
  mysql_config = (
    var.mysql_config == null
    ? data.terraform_remote_state.db[0].outputs
    : var.mysql_config
  )

  # Use vpc_id from var if provided, otherwise fetch the default VPC ID
  vpc_id = (
    var.vpc_id == null
    ? data.aws_vpc.default[0].id
    : var.vpc_id
  )

  # Use subnet_ids from var if provided, otherwise fetch default subnets
  subnet_ids = (
    var.subnet_ids == null
    ? data.aws_subnets.default[0].ids
    : var.subnet_ids
  )
}
