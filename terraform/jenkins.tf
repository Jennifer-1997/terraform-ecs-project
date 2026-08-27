resource "aws_security_group" "jenkins" {
  name        = "ecs-project-jenkins-sg"
  description = "Security group for Jenkins server"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ecs-project-jenkins-sg"
    Environment = "dev"
    Project     = "ECS Project"
  }
}

resource "aws_iam_role" "jenkins" {
  name = "ecs-project-jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "ecs-project-jenkins-role"
    Environment = "dev"
    Project     = "ECS Project"
  }
}

resource "aws_iam_policy" "jenkins" {
  name        = "ecs-project-jenkins-policy"
  description = "Permissions for Jenkins to push images to ECR and deploy ECS"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage"
        ]

        Resource = aws_ecr_repository.app.arn
      },
      {
        Effect = "Allow"

        Action = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService"
        ]

        Resource = "*"
      },
      {
        Effect = "Allow"

        Action = [
          "iam:PassRole"
        ]

        Resource = aws_iam_role.ecs_task_execution.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins.arn
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "ecs-project-jenkins-profile"
  role = aws_iam_role.jenkins.name
}

resource "aws_instance" "jenkins" {
  ami           = "ami-07e5ce642bbc48c0d"
  instance_type = "t3.medium"

  subnet_id = module.network.public_subnet_ids[0]

  vpc_security_group_ids = [
    aws_security_group.jenkins.id
  ]

  key_name = "ecs-project-jenkins-key"

  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  user_data = <<-EOF
              #!/bin/bash
              set -eux

              apt-get update

              # Install Java 17, Git, curl and unzip
              apt-get install -y \
                openjdk-17-jre \
                git \
                curl \
                unzip

              # Install Docker
              curl -fsSL https://get.docker.com | sh

              systemctl enable docker
              systemctl start docker

              # Install Jenkins
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
                -o /usr/share/keyrings/jenkins-keyring.asc

              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
                > /etc/apt/sources.list.d/jenkins.list

              apt-get update
              apt-get install -y jenkins

              # Allow Jenkins to use Docker
              usermod -aG docker jenkins

              systemctl enable jenkins
              systemctl restart jenkins
              EOF

  tags = {
    Name        = "ecs-project-jenkins"
    Environment = "dev"
    Project     = "ECS Project"
  }
}