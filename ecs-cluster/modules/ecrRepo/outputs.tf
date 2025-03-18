output "repository_url_flask" {
  value = aws_ecr_repository.flask_repo.repository_url
}

output "repository_url_angular" {
  value = aws_ecr_repository.angular_repo.repository_url
}