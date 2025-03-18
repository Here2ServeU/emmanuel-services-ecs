resource "aws_alb" "alb" {
  name               = var.load_balancer_name
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = var.security_groups
}

resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_name
  port        = var.backend_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}