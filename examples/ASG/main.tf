terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

#Import the module and set the values
module "asg" {
  source = "../../modules/cluster"

  cluster_name = var.cluster_name

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  min_size           = 1
  max_size           = 1
  enable_autoscaling = false

  subnet_ids = data.aws_subnets.default.ids
}

#fetch the latest AMI for Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}