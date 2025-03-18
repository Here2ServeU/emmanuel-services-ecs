locals {
 # Networking
  vpc_id                 = "vpc-02110db7947ceb3f5"
  subnets                = ["subnet-05cb29a9a04e93491", "subnet-07af10aa454f0b1a5", "subnet-0fd1861f670e2f8a6"]
  security_groups        = ["sg-07bdae1116f8a861c"]
 
 # Terraform State Storage
  bucket_name = "emmanuel-tf-emmanuel"
  table_name  = "emmanuelTfemmanuel"

  # Amazon ECR Repositories
  ecr_repo_name_flask   = "flask-backend-ecr-repo"
  ecr_repo_name_angular = "angular-frontend-ecr-repo"

  # ECS Cluster Configuration
  cluster_name       = "emmanuel-app-cluster"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # Flask Backend ECS Task Configuration
  flask_task_family          = "flask-backend-task"
  flask_task_name            = "flask-backend-task"
  flask_container_port       = 5050
  ecs_task_execution_role_name = "emmanuel-app-task-execution-role"

  # Angular Frontend ECS Task Configuration
  angular_task_family    = "angular-frontend-task"
  angular_task_name      = "angular-frontend-task"
  angular_container_port = 8080

  # Load Balancer & Target Groups
  flask_backend_alb_name = "flask-backend-alb"
  flask_backend_tg_name  = "flask-backend-tg"

  angular_frontend_alb_name = "angular-frontend-alb"
  angular_frontend_tg_name  = "angular-frontend-tg"

  # ECS Services
  flask_backend_service_name   = "flask-backend-service"
  angular_frontend_service_name = "angular-frontend-service"
}