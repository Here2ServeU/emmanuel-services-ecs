# Create ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

# Define Node.js Frontend ECS Task
resource "aws_ecs_task_definition" "node_task" {
  family                   = var.node_task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  cpu    = "512"  
  memory = "1024" 

  container_definitions = jsonencode([
    {
      name  = var.node_service_name
      image = var.node_ecr_repo_url
      essential = true
      portMappings = [
        {
          containerPort = var.node_container_port
          hostPort      = var.node_container_port
        }
      ]
    }
  ])
}

# Node.js Frontend Load Balancer & Target Group
resource "aws_alb" "node_frontend_alb" {
  name               = "node-frontend-${random_id.suffix.hex}"
  load_balancer_type = "application"
  subnets           = var.subnets
  security_groups   = [aws_security_group.load_balancer_security_group.id]
}

resource "aws_lb_target_group" "node_target_group" {
  name        = "node-tg-${random_id.suffix.hex}"
  port        = var.node_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id
}

resource "aws_lb_listener" "node_listener" {
  load_balancer_arn = aws_alb.node_frontend_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.node_target_group.arn
  }
}

# Attach Target Group to Load Balancer
resource "aws_alb_target_group_attachment" "node_tg_attachment" {
  target_group_arn = aws_lb_target_group.node_target_group.arn
  target_id        = aws_alb.node_frontend_alb.id  
  port            = var.node_container_port
}

# Deploy Node.js Frontend ECS Service
resource "aws_ecs_service" "node_service" {
  name            = var.node_service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.node_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.node_target_group.arn
    container_name   = aws_ecs_task_definition.node_task.family
    container_port   = var.node_container_port
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.service_security_group.id]
  }
}

output "node_task_definition" {
  value = aws_ecs_task_definition.node_task.arn
}