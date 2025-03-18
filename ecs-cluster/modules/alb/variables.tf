variable "load_balancer_name" { type = string }
variable "target_group_name" { type = string }
variable "vpc_id" { type = string }
variable "backend_container_port" { type = number }
variable "subnets" { type = list(string) }
variable "security_groups" { type = list(string) }