variable "project_name" {
  description = "Project name"
  type        = string
  default     = "ecs-project"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}