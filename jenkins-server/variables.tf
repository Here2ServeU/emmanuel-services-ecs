variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Jenkins EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key name for accessing the instance"
  type        = string
}

variable "private_key_filename" {
  description = "Name of the private key file"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Jenkins server will be deployed"
  type        = string
  default    = "null"
}

variable "allowed_cidr_blocks" {
  description = "Allowed CIDR blocks for security group rules"
  type        = list(string)
}

variable "iam_role_name" {
  description = "IAM role name for Jenkins EC2 instance"
  type        = string
}

variable "iam_policy_arn" {
  description = "IAM policy ARN for Jenkins"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

variable "instance_name" {
  description = "Tag for Jenkins EC2 instance"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key name for Jenkins EC2 instance"
  type        = string
}