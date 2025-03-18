variable "cluster_name" { type = string }
variable "subnets" { type = list(string) }
variable "security_groups" { type = list(string) }

variable "flask_service_name" { type = string }
variable "flask_task_definition" { type = string }
variable "flask_target_group_arn" { type = string }
variable "flask_container_port" { type = number }

variable "angular_service_name" { type = string }
variable "angular_task_definition" { type = string }
variable "angular_target_group_arn" { type = string }
variable "angular_container_port" { type = number }