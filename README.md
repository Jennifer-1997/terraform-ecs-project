# AWS ECS Fargate CI/CD Pipeline using Terraform

## Project Overview

This project demonstrates an end-to-end CI/CD pipeline for deploying a containerized application on AWS ECS Fargate using Terraform Infrastructure as Code (IaC).

The infrastructure is provisioned using Terraform, the application is containerized using Docker, images are stored in Amazon ECR, and Jenkins automates the deployment process through GitHub integration.

---

## Architecture

![AWS ECS Fargate CI/CD Architecture]

- Custom VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Public & Private Route Tables
- Security Groups
- Application Load Balancer (ALB)
- Amazon ECS Fargate
- Amazon ECR
- Jenkins on EC2
- CloudWatch Logs
- Amazon S3 Terraform Remote State
- Reusable Terraform Network Module

---

## CI/CD Workflow

GitHub
   |
   | Webhook
   v
Jenkins
   |
   | Docker Build
   v
Amazon ECR
   |
   | New Image
   v
ECS Task Definition
   |
   v
ECS Fargate
   |
   v
Application Load Balancer
   |
   v
Live Application

Services & Tools Used
Terraform
AWS VPC
Amazon ECS Fargate
Amazon ECR
Amazon EC2
Application Load Balancer
IAM
Amazon S3
CloudWatch
Docker
Jenkins
Git
GitHub

Project Structure
.
├── app/
│   ├── app.py
│   └── requirements.txt
│
├── docker/
│   └── Dockerfile
│
├── jenkins/
│
├── screenshots/
│   ├── aws-ecs-cicd-architecture.png
│   ├── alb-application.png
│   ├── ecr-images.png
│   ├── ecs-service.png
│   └── jenkins-pipeline.png
│
├── terraform/
│   ├── modules/
│   │   └── network/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   ├── alb.tf
│   ├── backend.tf
│   ├── ecr.tf
│   ├── ecs.tf
│   ├── ecs-service.tf
│   ├── iam.tf
│   ├── jenkins.tf
│   ├── logs.tf
│   ├── provider.tf
│   ├── security-groups.tf
│   ├── task-definition.tf
│   ├── variables.tf
│   ├── versions.tf
│   ├── main.tf
│   └── moved.tf
│
├── Jenkinsfile
├── .gitignore
└── README.md

Deployment Steps
terraform init

terraform fmt

terraform validate

terraform plan

terraform apply

The Jenkins pipeline then automates the application deployment:
1. Checkout source code
2. Build Docker image
3. Login to Amazon ECR
4. Push image to ECR
5. Create new ECS task definition
6. Deploy updated task definition
7. Wait for ECS service stabilization

Key Features
Infrastructure as Code using Terraform
Reusable Terraform Network Module
Dockerized Application
Automated Jenkins CI/CD Pipeline
GitHub Webhook Integration
Amazon ECR Image Management
ECS Fargate Deployment
Application Load Balancer
Private Subnet Deployment
Multi-AZ Networking
Two Running ECS Tasks
CloudWatch Logging
Terraform Remote State using Amazon S3

Deployment Verification
Jenkins Pipeline

Amazon ECR

ECS Fargate Service

Application through ALB

Learning Outcomes

Through this project I gained hands-on experience with:

Terraform Infrastructure as Code
Terraform Modules
Terraform State Management
AWS Networking
Docker Containerization
Amazon ECR
Amazon ECS Fargate
Application Load Balancer
Jenkins CI/CD
GitHub Webhooks
IAM Roles and Policies
CloudWatch Logging
CI/CD Troubleshooting
AWS Deployment Automation
Key Takeaway

This project helped me understand how Infrastructure as Code, containerization, cloud services, and CI/CD automation work together to deliver an application from source code to production.

Author

Jennifer

Cloud & DevOps Engineer