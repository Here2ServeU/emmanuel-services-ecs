resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = var.availability_zones[0]
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = var.availability_zones[1]
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = var.availability_zones[2]
}

# Flask Backend ECS Task Definition
resource "aws_ecs_task_definition" "flask_task" {
  family                   = var.flask_task_family
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.flask_task_name}",
      "image": "${var.flask_ecr_repo_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.flask_container_port},
          "hostPort": ${var.flask_container_port}
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

# Angular Frontend ECS Task Definition
resource "aws_ecs_task_definition" "angular_task" {
  family                   = var.angular_task_family
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.angular_task_name}",
      "image": "${var.angular_ecr_repo_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.angular_container_port},
          "hostPort": ${var.angular_container_port}
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Flask Backend Load Balancer and Target Group
resource "aws_alb" "flask_backend_alb" {
  name               = var.flask_backend_alb_name
  load_balancer_type = "application"
  subnets = [
    aws_default_subnet.default_subnet_a.id,
    aws_default_subnet.default_subnet_b.id,
    aws_default_subnet.default_subnet_c.id
  ]
  security_groups = [aws_security_group.load_balancer_security_group.id]
}

resource "aws_lb_target_group" "flask_target_group" {
  name        = var.flask_backend_tg_name
  port        = var.flask_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id
}

resource "aws_lb_listener" "flask_listener" {
  load_balancer_arn = aws_alb.flask_backend_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_target_group.arn
  }
}

# Angular Frontend Load Balancer and Target Group
resource "aws_alb" "angular_frontend_alb" {
  name               = var.angular_frontend_alb_name
  load_balancer_type = "application"
  subnets = [
    aws_default_subnet.default_subnet_a.id,
    aws_default_subnet.default_subnet_b.id,
    aws_default_subnet.default_subnet_c.id
  ]
  security_groups = [aws_security_group.load_balancer_security_group.id]
}

resource "aws_lb_target_group" "angular_target_group" {
  name        = var.angular_frontend_tg_name
  port        = var.angular_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id
}

resource "aws_lb_listener" "angular_listener" {
  load_balancer_arn = aws_alb.angular_frontend_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.angular_target_group.arn
  }
}

# Flask Backend ECS Service
resource "aws_ecs_service" "flask_service" {
  name            = var.flask_service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.flask_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.flask_target_group.arn
    container_name   = aws_ecs_task_definition.flask_task.family
    container_port   = var.flask_container_port
  }

  network_configuration {
    subnets          = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id, aws_default_subnet.default_subnet_c.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.service_security_group.id]
  }
}

# Angular Frontend ECS Service
resource "aws_ecs_service" "angular_service" {
  name            = var.angular_service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.angular_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.angular_target_group.arn
    container_name   = aws_ecs_task_definition.angular_task.family
    container_port   = var.angular_container_port
  }

  network_configuration {
    subnets          = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id, aws_default_subnet.default_subnet_c.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.service_security_group.id]
  }
}

resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "service_security_group" {
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}