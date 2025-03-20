locals {
  # Networking
  vpc_id          = "vpc-02110db7947ceb3f5"
  subnets         = ["subnet-05cb29a9a04e93491", "subnet-07af10aa454f0b1a5", "subnet-0fd1861f670e2f8a6"]
  security_groups = ["sg-07bdae1116f8a861c"]

  # Terraform State Storage
  bucket_name = "emmanuel-tf-services"
  table_name  = "emmanuelTfservices"

  # Amazon ECR Repositories
  ecr_repo_name_flask = "flask-backend-ecr-repo"
  ecr_repo_name_node  = "node-frontend-ecr-repo"

  # ECS Cluster Configuration
  cluster_name                 = "emmanuel-app-cluster"
  availability_zones           = ["us-east-1a", "us-east-1b", "us-east-1c"]
  ecs_task_execution_role_name = "emmanuel-app-task-execution-role"

  # Flask Backend ECS Task Configuration
  flask_task_family       = "flask-backend-task"
  flask_task_name         = "flask-backend-task"
  flask_container_port    = 5050
  flask_ecr_repo_url      = "730335276920.dkr.ecr.us-east-1.amazonaws.com/${local.ecr_repo_name_flask}"
  flask_backend_alb_name  = "flask-backend-alb"
  flask_target_group_name = "flask-tg"
  flask_target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:730335276920:targetgroup/flask-backend-tg/abcdef"
  flask_service_name      = "flask-backend-service"
  flask_backend_tg_name   = "flask-tg"

  # Node.js Frontend ECS Task Configuration (Replacing Angular)
  node_task_family       = "node-frontend-task"
  node_task_name         = "node-frontend-task"
  node_container_port    = 8080
  node_ecr_repo_url      = "730335276920.dkr.ecr.us-east-1.amazonaws.com/${local.ecr_repo_name_node}"
  node_frontend_alb_name = "node-frontend-alb"
  node_target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:730335276920:targetgroup/node-frontend-tg/abcdef"
  node_service_name      = "node-frontend-service"
  node_frontend_tg_name  = "node-tg"
}