terraform {
  backend "s3" {
    bucket       = "terraform-ecs-project-state-devops-130297"
    key          = "ecs-project/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}