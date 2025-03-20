output "flask_target_group_arn" {
  value = aws_lb_target_group.flask_target_group.arn
}

output "node_target_group_arn" {
  value = aws_lb_target_group.node_target_group.arn
}