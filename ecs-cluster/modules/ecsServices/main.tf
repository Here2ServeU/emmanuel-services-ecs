resource "aws_ecs_service" "flask_service" {
  name            = var.flask_service_name
  cluster         = var.cluster_name
  task_definition = var.flask_task_definition
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = var.flask_target_group_arn
    container_name   = var.flask_service_name
    container_port   = var.flask_container_port
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = var.security_groups
  }
}

resource "aws_ecs_service" "node_service" {
  name            = var.node_service_name
  cluster         = var.cluster_name
  task_definition = var.node_task_definition
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = var.node_target_group_arn
    container_name   = var.node_service_name
    container_port   = var.node_container_port
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = var.security_groups
  }
}