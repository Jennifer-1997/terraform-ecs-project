resource "aws_ecs_service" "app" {
  name            = "ecs-demo-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn

  desired_count = 2

  launch_type = "FARGATE"

  lifecycle {
  ignore_changes = [
    task_definition
  ]
}

  network_configuration {
    subnets = [
      module.network.private_subnet_ids[0],
      module.network.private_subnet_ids[1]
    ]

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "ecs-demo"
    container_port   = 8080
  }

  depends_on = [
    aws_lb_listener.http
  ]

  tags = {
    Name        = "ecs-demo-service"
    Environment = "dev"
    Project     = "ECS Project"
  }
}