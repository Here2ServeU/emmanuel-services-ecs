variable "cluster_name" { 
  type = string 
}

variable "subnets" { 
  type = list(string) 
}

variable "security_groups" { 
  type = list(string) 
}

# Flask Backend Variables
variable "flask_service_name" { 
  type = string 
}

variable "flask_task_definition" { 
  type = string 
}

variable "flask_target_group_arn" { 
  type = string 
}

variable "flask_container_port" { 
  type = number 
}

# Node.js Frontend Variables (Replaced Angular)
variable "node_service_name" { 
  type = string 
}

variable "node_task_definition" { 
  type = string 
}

variable "node_target_group_arn" { 
  type = string 
}

variable "node_container_port" { 
  type = number 
}