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

resource "aws_ecr_repository" "node_repo" {
  name                 = var.ecr_repo_name_node
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "node_repo_policy" {
  repository = aws_ecr_repository.node_repo.name
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