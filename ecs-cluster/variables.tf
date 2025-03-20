variable "ecs_task_execution_role_name" {
  description = "Name of the ECS Task Execution Role"
  type        = string
}

variable "subnets" {
  description = "List of subnets for ECS services"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security groups for ECS services"
  type        = list(string)
}

variable "flask_service_name" {
  description = "Service name for Flask backend"
  type        = string
}

variable "flask_target_group_arn" {
  description = "Target group ARN for Flask backend ALB"
  type        = string
}

variable "node_service_name" {
  description = "Service name for Node frontend"
  type        = string
}

variable "node_target_group_arn" {
  description = "Target group ARN for Node frontend ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for networking"
  type        = string
}

variable "node_container_port" {
  description = "Value of the Node container port"
  type        = number
}

variable "flask_container_port" {
  description = "Value of the Flask container port"
  type        = number
}