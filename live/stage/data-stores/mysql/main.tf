terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "s3-state-bucket-ssk"
    key = "live/stage/data-stores/mysql/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
    dynamodb_table = "terraform_locks_table_ssk"
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-exercise"
  engine              = "mysql"
  engine_version = "8.0"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
}
