terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "s3-state-bucket-ssk"
    key            = "live/stage/data-stores/mysql/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform_locks_table_ssk"
  }
}

provider "aws" {
  region = "eu-central-1"
  alias  = "primary"
}

provider "aws" {
  region = "eu-west-3"
  alias  = "replica"
}

resource "aws_db_instance" "example" {
  identifier_prefix       = "terraform-exercise"
  engine_version          = "8.0"
  allocated_storage       = 10
  instance_class          = "db.t3.micro"
  skip_final_snapshot     = true
  backup_retention_period = var.backup_retention_preiod
  replicate_source_db     = var.replicate_source_db

  engine   = var.replicate_source_db == null ? "mysql" : null
  db_name  = var.replicate_source_db == null ? var.db_name : null
  username = var.replicate_source_db == null ? var.db_username : null
  password = var.replicate_source_db == null ? var.db_password : null
}
