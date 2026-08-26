resource "aws_ecr_repository" "app" {
  name                 = "ecs-demo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "ecs-demo"
    Environment = "dev"
    Project     = "ECS Project"
  }
}