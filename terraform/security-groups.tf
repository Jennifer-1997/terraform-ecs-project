resource "aws_security_group" "alb" {
  name        = "ecs-project-alb-sg"
  description = "Security group for the ECS Application Load Balancer"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "Allow HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-project-alb-sg"
  }
}

resource "aws_security_group" "ecs" {
  name        = "ecs-project-ecs-sg"
  description = "Security group for ECS Fargate tasks"
  vpc_id      = module.network.vpc_id

  ingress {
    description     = "Allow application traffic from the ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-project-ecs-sg"
  }
}