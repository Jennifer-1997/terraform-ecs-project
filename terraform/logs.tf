resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/ecs-demo"
  retention_in_days = 7

  tags = {
    Name        = "ecs-demo-logs"
    Environment = "dev"
    Project     = "ECS Project"
  }
}