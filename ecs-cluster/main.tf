terraform {
  required_version = "~> 1.3"

  backend "s3" {
    bucket         = "cc-tf-emmanuel"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ccTfemmanuel"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Terraform Backend State Storage
module "tf-state" {
  source      = "./modules/tf-state"
  bucket_name = local.bucket_name
  table_name  = local.table_name
}

# Amazon ECR Repository for Flask and Angular
module "ecrRepo" {
  source = "./modules/ecr"

  ecr_repo_name_flask   = local.ecr_repo_name_flask
  ecr_repo_name_angular = local.ecr_repo_name_angular
}

# Amazon ECS Cluster
module "ecsCluster" {
  source               = "./modules/ecs"
  cluster_name         = local.cluster_name
  availability_zones   = local.availability_zones

  # Flask Backend Task Definition
  flask_task_family         = local.flask_task_family
  flask_task_name           = local.flask_task_name
  flask_container_port      = local.flask_container_port
  flask_task_execution_role = local.ecs_task_execution_role_name
  flask_ecr_repo_url        = module.ecrRepo.repository_url_flask

  # Angular Frontend Task Definition
  angular_task_family         = local.angular_task_family
  angular_task_name           = local.angular_task_name
  angular_container_port      = local.angular_container_port
  angular_task_execution_role = local.ecs_task_execution_role_name
  angular_ecr_repo_url        = module.ecrRepo.repository_url_angular
}

# Flask Backend Load Balancer and Target Group
module "flask_backend_alb" {
  source                 = "./modules/alb"
  load_balancer_name     = local.flask_backend_alb_name
  target_group_name      = local.flask_backend_tg_name
  vpc_id                 = local.vpc_id
  backend_container_port = local.flask_container_port
  subnets                = local.subnets
  security_groups        = local.security_groups
}

# Angular Frontend Load Balancer and Target Group
module "angular_frontend_alb" {
  source                 = "./modules/alb"
  load_balancer_name     = local.angular_frontend_alb_name
  target_group_name      = local.angular_frontend_tg_name
  vpc_id                 = local.vpc_id
  backend_container_port = local.angular_container_port
  subnets                = local.subnets
  security_groups        = local.security_groups
}

# ECS Services for Flask Backend and Angular Frontend
module "ecsServices" {
  source = "./modules/ecs-service"

  cluster_name   = local.cluster_name
  subnets        = local.subnets
  security_groups = local.security_groups

  # Flask Backend Service
  flask_service_name       = local.flask_service_name
  flask_task_definition    = module.ecsCluster.flask_task_definition
  flask_target_group_arn   = module.flask_backend_alb.target_group_arn
  flask_container_port     = local.flask_container_port

  # Angular Frontend Service
  angular_service_name     = local.angular_service_name
  angular_task_definition  = module.ecsCluster.angular_task_definition
  angular_target_group_arn = module.angular_frontend_alb.target_group_arn
  angular_container_port   = local.angular_container_port
}