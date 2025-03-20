terraform {
  required_version = ">= 1.3"

  backend "s3" {
    bucket         = "emmanuel-tf-services"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "emmanuelTfservices"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Amazon ECR Repository for Flask and Node.js
module "ecrRepo" {
  source = "./modules/ecrRepo"

  ecr_repo_name_flask = local.ecr_repo_name_flask
  ecr_repo_name_node  = local.ecr_repo_name_node
}

# Amazon ECS Cluster
module "ecsCluster" {
  source = "./modules/ecsCluster"

  cluster_name                 = local.cluster_name
  ecs_task_execution_role_name = local.ecs_task_execution_role_name

  # Flask Backend Task Definition
  flask_task_family      = local.flask_task_family
  flask_task_name        = local.flask_task_name
  flask_container_port   = local.flask_container_port
  flask_ecr_repo_url     = local.flask_ecr_repo_url
  flask_backend_tg_name  = local.flask_backend_tg_name  # 🔹 Now correctly defined

  # Angular Frontend Task Definition
  # Removed Angular task attributes as they are not expected by the ecsCluster module
}
module "ecsServices" {
  source = "./modules/ecsServices"

  cluster_name    = local.cluster_name
  subnets         = local.subnets
  security_groups = local.security_groups

  # Flask Backend Service
  flask_service_name     = local.flask_service_name
  flask_task_definition  = module.ecsCluster.flask_task_definition
  flask_target_group_arn = module.alb.flask_target_group_arn
  flask_container_port   = local.flask_container_port

  # Node Frontend Service
  node_service_name     = local.node_service_name
  node_task_definition  = module.ecsCluster.node_task_definition
  node_target_group_arn = module.alb.node_target_group_arn
  node_container_port   = local.node_container_port
}

module "alb" {
  source = "./modules/alb"

  vpc_id              = local.vpc_id
  subnets             = local.subnets
  security_groups     = local.security_groups
  availability_zones  = ["us-east-1a", "us-east-1b"]

  # Flask Backend Load Balancer and Target Group
  flask_load_balancer_name   = local.flask_backend_alb_name
  flask_backend_tg_name      = local.flask_target_group_name
  flask_target_group_arn     = module.ecsServices.flask_target_group_arn
  flask_container_port       = local.flask_container_port

  # Node Frontend Load Balancer and Target Group
  node_load_balancer_name   = local.node_frontend_alb_name
  node_frontend_tg_name     = local.node_frontend_tg_name
  node_target_group_arn     = module.ecsServices.node_target_group_arn
  node_container_port       = local.node_container_port
}