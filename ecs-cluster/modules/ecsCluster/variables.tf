# General Configuration
variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones for ECS"
  type        = list(string)
}

variable "ecs_task_execution_role_name" {
  description = "IAM role for ECS task execution"
  type        = string
}

variable "subnets" {
  description = "List of subnets for ECS tasks"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where ECS is deployed"
  type        = string
}

variable "security_groups" {
  description = "Security groups for ECS tasks"
  type        = list(string)
}

# Flask Backend Variables
variable "flask_task_family" {
  description = "Flask ECS task family name"
  type        = string
}

variable "flask_task_name" {
  description = "Flask ECS task name"
  type        = string
}

variable "flask_container_port" {
  description = "Flask container port"
  type        = number
}

variable "flask_ecr_repo_url" {
  description = "ECR repository URL for Flask backend"
  type        = string
}

variable "flask_backend_alb_name" {
  description = "Flask backend ALB name"
  type        = string
}

variable "flask_backend_tg_name" {
  description = "Flask backend target group name"
  type        = string
}

variable "flask_service_name" {
  description = "Flask ECS service name"
  type        = string
}

variable "flask_target_group_arn" {
  description = "Flask ALB target group ARN"
  type        = string
}

# Node.js Frontend Variables (Replacing Angular)
variable "node_task_family" {
  description = "Node.js ECS task family name"
  type        = string
}

variable "node_task_name" {
  description = "Node.js ECS task name"
  type        = string
}

variable "node_container_port" {
  description = "Node.js container port"
  type        = number
}

variable "node_ecr_repo_url" {
  description = "ECR repository URL for Node.js frontend"
  type        = string
}

variable "node_frontend_alb_name" {
  description = "Node.js frontend ALB name"
  type        = string
}

variable "node_frontend_tg_name" {
  description = "Node.js frontend target group name"
  type        = string
}

variable "node_service_name" {
  description = "Node.js ECS service name"
  type        = string
}

variable "node_target_group_arn" {
  description = "Node.js ALB target group ARN"
  type        = string
}