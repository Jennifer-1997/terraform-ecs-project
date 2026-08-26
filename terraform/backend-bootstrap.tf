resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-ecs-project-state-devops-130297"

  tags = {
    Name        = "Terraform Remote State"
    Environment = "shared"
    Project     = "ECS Project"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}