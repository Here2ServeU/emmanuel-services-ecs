output "repository_url_flask" {
  value = aws_ecr_repository.flask_repo.repository_url
}

output "repository_url_node" {
  value = aws_ecr_repository.node_repo.repository_url
}