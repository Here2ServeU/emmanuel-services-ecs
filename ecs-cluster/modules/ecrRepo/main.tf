resource "aws_ecr_repository" "flask_repo" {
  name                 = var.ecr_repo_name_flask
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "flask_repo_policy" {
  repository = aws_ecr_repository.flask_repo.name
  policy     = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Expire images older than 30 days",
        "selection": {
          "tagStatus": "untagged",
          "countType": "sinceImagePushed",
          "countUnit": "days",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}

resource "aws_ecr_repository" "angular_repo" {
  name                 = var.ecr_repo_name_angular
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "angular_repo_policy" {
  repository = aws_ecr_repository.angular_repo.name
  policy     = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Expire images older than 30 days",
        "selection": {
          "tagStatus": "untagged",
          "countType": "sinceImagePushed",
          "countUnit": "days",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}