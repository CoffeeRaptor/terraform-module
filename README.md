# AWS Infrastructure with Terraform

This repository contains Terraform code for managing various AWS infrastructure components, including EC2 instances, databases, S3 buckets, Auto Scaling Groups (ASG), and more. The goal is to automate the deployment and configuration of essential AWS services to create a scalable and reliable cloud environment.

## About This Project

The code in this repository draws inspiration from the book *Terraform: Up & Running (3rd Edition)* by Yevgeniy Brikman. The book provides practical examples of infrastructure as code (IaC) principles, and this repository adapts those concepts to build AWS infrastructure using Terraform. ["Terraform Up & Running"] (https://www.terraformupandrunning.com/) by [Yevgeniy Brikman](https://github.com/brikis98). 

### AWS Components Used

## AWS Components Used

- **EC2 Instances**: These are the virtual servers that run the application. Managed through an Auto Scaling Group with configurations for AMI, instance type, and user data scripts.
- **Auto Scaling Groups (ASG)**: Handles scaling EC2 instances up or down based on demand. Includes features like rolling updates and scheduled scaling.
- **Elastic Load Balancer (ALB)**: Distributes incoming HTTP traffic across the EC2 instances. Configured with listeners and rules to manage traffic efficiently.
- **Target Groups**: Registers EC2 instances with the ALB to route traffic. Also has health checks to monitor which instances are healthy.
- **Security Groups**: Manages what kind of traffic can go in and out of the EC2 instances and the ALB. Includes rules for HTTP and outbound traffic.
- **CloudWatch Alarms**: Tracks metrics like CPU usage and sends alerts when something exceeds the set thresholds. Helps ensure the application is performing well.
- **VPC and Subnets**: All resources are deployed inside a Virtual Private Cloud (VPC) and specific subnets for better network isolation and control.
- **S3 Buckets (Terraform Remote State)**: Used to store Terraform state files and fetch configurations dynamically, like database details.
- **Databases**: Includes MySQL database configurations, like address and port, which are fetched either from input variables or remote state.
- **Modules**: Reusable Terraform modules for things like ASGs and ALBs. Makes managing configurations consistent and easier.
