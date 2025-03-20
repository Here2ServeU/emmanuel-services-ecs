# Flask Backend Load Balancer
resource "aws_alb" "flask_backend_alb" {
  name               = var.flask_load_balancer_name
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = var.security_groups
}

resource "aws_lb_target_group" "flask_target_group" {
  name        = var.flask_backend_tg_name
  port        = var.flask_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
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

# Node.js Frontend Load Balancer
resource "aws_alb" "node_frontend_alb" {
  name               = var.node_load_balancer_name
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = var.security_groups
}

resource "aws_lb_target_group" "node_target_group" {
  name        = var.node_frontend_tg_name
  port        = var.node_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
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