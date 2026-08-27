# AWS ECS Fargate CI/CD Project

## Project Overview

This project demonstrates an end-to-end DevOps CI/CD workflow for deploying a containerized application on AWS ECS Fargate.

The infrastructure is provisioned using Terraform, the application is containerized using Docker, container images are stored in Amazon ECR, and Jenkins automates the build and deployment process whenever changes are pushed to GitHub.

The application is exposed to the internet through an AWS Application Load Balancer.

---

## Architecture

```text
                         GitHub
                           |
                           | Webhook
                           v
                       Jenkins EC2
                           |
                    +------+------+
                    |             |
               Docker Build    AWS CLI
                    |             |
                    v             v
                Amazon ECR    ECS Deployment
                    |             |
                    |       New Task Definition
                    |             |
                    +-------> ECS Fargate
                                  |
                         +--------+--------+
                         |                 |
                    Fargate Task 1    Fargate Task 2
                         |                 |
                         +--------+--------+
                                  |
                         Application Load
                            Balancer
                                  |
                                  v
                           Web Application

Technologies Used

| Technology                | Purpose                                        |
| ------------------------- | ---------------------------------------------- |
| AWS VPC                   | Network infrastructure                         |
| AWS Subnets               | Public and private networking                  |
| Internet Gateway          | Internet connectivity for public resources     |
| NAT Gateway               | Outbound internet access for private resources |
| Application Load Balancer | Load balancing and public application access   |
| Amazon ECS Fargate        | Container orchestration                        |
| Amazon ECR                | Docker image registry                          |
| Amazon EC2                | Jenkins server                                 |
| Jenkins                   | CI/CD automation                               |
| GitHub                    | Source code management                         |
| Docker                    | Application containerization                   |
| Terraform                 | Infrastructure as Code                         |
| IAM                       | AWS access control                             |
| CloudWatch Logs           | Application and container logging              |
| Amazon S3                 | Terraform remote state storage                 |

Infrastructure Provisioned with Terraform

Terraform is used to provision and manage the AWS infrastructure.

The project provisions:

VPC
Public and private subnets
Internet Gateway
NAT Gateway
Public and private route tables
Security Groups
Application Load Balancer
ALB Target Group
ALB Listener
Amazon ECR repository
ECS Cluster
ECS Fargate Service
ECS Task Definition
IAM Roles and Policies
CloudWatch Log Group
Jenkins EC2 instance
Amazon S3 backend for Terraform remote state
Terraform Reusable Module

The network layer has been converted into a reusable Terraform module.

Network Module Structure
terraform/
└── modules/
    └── network/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

The network module manages:

VPC
Public subnets
Private subnets
Internet Gateway
NAT Gateway
Route tables
Route table associations

The module uses variables and outputs so the same network configuration can be reused across different environments without duplicating infrastructure code.

Example Module Usage
module "network" {
  source = "./modules/network"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

This approach makes the infrastructure more maintainable and reusable.

Application

The project uses a simple Python application to demonstrate the complete CI/CD workflow.

Application Structure
app/
├── app.py
└── requirements.txt

The application listens on port 8080.

The application is packaged into a Docker image and deployed as an ECS Fargate task.

Docker

The application is containerized using Docker.

The Dockerfile is located at:

docker/Dockerfile

The Docker image is built by Jenkins and tagged with a version number.

Example image versions:

ecs-demo:1
ecs-demo:2
ecs-demo:3

Versioned Docker images allow application releases to be tracked and deployed independently.

Amazon ECR

Amazon Elastic Container Registry is used as the private Docker image registry.

Repository:

ecs-demo

Jenkins builds the Docker image and pushes the image to Amazon ECR.

Example:

431856072251.dkr.ecr.ap-south-1.amazonaws.com/ecs-demo:3
ECR Screenshot

Amazon ECS Fargate

The application runs on Amazon ECS using the Fargate launch type.

The ECS service is configured with:

Desired count: 2
Launch type: Fargate
Private subnets
ECS security group
Application Load Balancer
Target group
Container port: 8080

Two ECS tasks are maintained by the service to provide availability.

ECS Service Screenshot

The screenshot demonstrates:

ECS service status is Active
Two tasks are running
Zero tasks are pending
Task definition revision 3 is deployed
Target group health checks are successful
Jenkins CI/CD Pipeline

Jenkins is hosted on an EC2 instance and is used to automate the application deployment process.

The pipeline is defined in:

Jenkinsfile
Pipeline Stages
Checkout source code from GitHub
Build Docker image
Authenticate with Amazon ECR
Push Docker image to ECR
Create a new ECS task definition revision
Update the ECS service
Wait for the ECS deployment to stabilize
Jenkins Pipeline Screenshot

The successful pipeline demonstrates the automated flow from source code checkout to ECS deployment.

GitHub Webhook

GitHub is integrated with Jenkins using a webhook.

Whenever code is pushed to the configured repository, GitHub sends a webhook notification to Jenkins and triggers the CI/CD pipeline.

CI/CD Trigger Flow
Developer
    |
    | git push
    v
GitHub
    |
    | Webhook
    v
Jenkins
    |
    v
Docker Build
    |
    v
Amazon ECR
    |
    v
Amazon ECS

This removes the need to manually start the Jenkins deployment job after every code change.

Complete Deployment Flow

The complete application deployment flow is:

Developer modifies application
             |
             v
        Git Commit
             |
             v
        GitHub Push
             |
             v
     GitHub Webhook
             |
             v
       Jenkins Pipeline
             |
             v
       Docker Build
             |
             v
       Amazon ECR
             |
             v
 New ECS Task Definition Revision
             |
             v
      ECS Fargate Service
             |
             v
       Fargate Tasks
             |
             v
   ALB Target Health Check
             |
             v
      Live Application
Application Load Balancer

The Application Load Balancer provides public access to the ECS application.

Traffic is forwarded from the ALB to the ECS tasks running inside private subnets.

The ALB performs health checks against the ECS target group to ensure traffic is sent only to healthy tasks.

Application Screenshot

The application was successfully accessed through the ALB after the Jenkins deployment.

Project Structure
terraform-ecs-project/
│
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
│   ├── alb-application.png
│   ├── ecr-images.png
│   ├── ecs-service.png
│   └── jenkins-pipeline.png
│
├── terraform/
│   │
│   ├── modules/
│   │   └── network/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   ├── main.tf
│   ├── variables.tf
│   ├── moved.tf
│   ├── provider.tf
│   ├── versions.tf
│   ├── alb.tf
│   ├── ecr.tf
│   ├── ecs.tf
│   ├── ecs-service.tf
│   ├── iam.tf
│   ├── jenkins.tf
│   ├── logs.tf
│   ├── security-groups.tf
│   └── task-definition.tf
│
├── Jenkinsfile
├── .gitignore
└── README.md
Security Practices

The project follows basic security practices:

AWS credentials are not committed to GitHub.
Private key files (.pem) are excluded from version control.
Terraform state files are excluded from Git.
Environment and secret files are excluded from Git.
IAM roles are used for AWS access from EC2 where applicable.
ECS tasks run inside private subnets.
Jenkins is protected using a dedicated security group.
Container images are stored in a private ECR repository.
Public access is provided through the Application Load Balancer rather than directly exposing ECS tasks.
Terraform State Management

Terraform state is stored remotely using Amazon S3.

Remote state provides centralized state storage and helps maintain consistent infrastructure management.

Terraform state files and sensitive configuration files are excluded from the Git repository.

Key DevOps Concepts Demonstrated
Infrastructure as Code

Terraform is used to provision and manage AWS infrastructure in a repeatable and version-controlled manner.

Terraform Modules

The network layer is implemented as a reusable module using variables and outputs.

This reduces code duplication and makes it easier to reuse the infrastructure for different environments.

Terraform State Management

Terraform state is stored remotely using Amazon S3, allowing infrastructure state to be managed centrally.

Containerization

The Python application is packaged into a Docker container.

Container Registry

Amazon ECR is used to store and version Docker images.

Container Orchestration

Amazon ECS Fargate is used to run and manage containerized workloads without managing EC2 instances for the application containers.

CI/CD

Jenkins automates the application build and deployment process.

GitHub Integration

GitHub acts as the source code repository and triggers Jenkins through a webhook.

Load Balancing

An Application Load Balancer distributes incoming traffic to healthy ECS tasks.

High Availability

Two ECS Fargate tasks are maintained behind the Application Load Balancer.

IAM

IAM roles and policies provide controlled AWS permissions to the required services.

Logging

CloudWatch Logs are used for ECS container and application logs.

CI/CD Deployment Result

The final deployment successfully demonstrated the complete CI/CD workflow.

The Jenkins pipeline:

Successfully checked out the source code
Built the Docker image
Pushed the image to Amazon ECR
Created a new ECS task definition revision
Updated the ECS service
Successfully deployed the application

The final ECS service was running two healthy tasks behind the Application Load Balancer.

Screenshots
Jenkins CI/CD Pipeline

Amazon ECR

ECS Fargate Service

Application Through ALB

Future Improvements

The following improvements can be added in future iterations:

Create additional Terraform modules for ALB, ECS and ECR
Introduce separate development, staging and production environments
Add Terraform plan and approval stages to Jenkins
Add production approval gates
Configure HTTPS using AWS Certificate Manager
Configure Route 53 for custom DNS
Add CloudWatch alarms and monitoring dashboards
Add Jenkins deployment notifications
Implement blue/green deployment
Add Docker image vulnerability scanning
Implement automated rollback on failed deployments
Conclusion

This project demonstrates an end-to-end AWS DevOps implementation using Terraform, Docker, Amazon ECR, Amazon ECS Fargate, Jenkins and GitHub.

The infrastructure is managed as code using Terraform, the application is containerized using Docker, and the CI/CD pipeline automates the process of building, publishing and deploying application versions.

The final workflow enables a code change pushed to GitHub to automatically progress through:

GitHub
   ↓
Jenkins
   ↓
Docker
   ↓
Amazon ECR
   ↓
ECS Fargate
   ↓
Application Load Balancer
   ↓
Live Application

This project provides practical hands-on experience with Infrastructure as Code, containerization, cloud networking, AWS container services, CI/CD automation, IAM, remote state management and reusable Terraform modules.