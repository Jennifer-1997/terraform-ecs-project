resource "aws_ecs_cluster" "main" {
  name = "ecs-project-cluster"

  tags = {
    Name        = "ecs-project-cluster"
    Environment = "dev"
    Project     = "ECS Project"
  }
}