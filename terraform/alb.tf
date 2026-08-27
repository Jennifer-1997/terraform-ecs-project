resource "aws_lb" "app" {
  name               = "ecs-project-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    module.network.public_subnet_ids[0],
    module.network.public_subnet_ids[1]
  ]

  tags = {
    Name        = "ecs-project-alb"
    Environment = "dev"
    Project     = "ECS Project"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "ecs-project-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.network.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name        = "ecs-project-tg"
    Environment = "dev"
    Project     = "ECS Project"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}