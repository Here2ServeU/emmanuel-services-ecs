variable "node_container_port" {
  description = "The port number for the Node.js container"
  type        = number
}

variable "vpc_id" {
  description = "VPC ID for ALB"
  type        = string
}

variable "subnets" {
  description = "List of subnets for ALB"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security groups for ALB"
  type        = list(string)
}

# Flask Backend Variables
variable "flask_load_balancer_name" {
  description = "Load Balancer name for Flask backend"
  type        = string
}

variable "flask_backend_tg_name" {
  description = "Target Group name for Flask backend"
  type        = string
}

variable "flask_container_port" {
  description = "Container port for Flask backend"
  type        = number
}

# Node.js Frontend Variables
variable "node_load_balancer_name" {
  description = "Load Balancer name for Node.js frontend"
  type        = string
}

variable "node_frontend_tg_name" {
  description = "Target Group name for Node.js frontend"
  type        = string
}