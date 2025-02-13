# Variables used within the 'webserver' module

variable "environment" {
  description = "The environment on which we're operating"
  type        = string
}

variable "namespace" {
  description = "The namespace in which we're operating"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the primary VPC"
  type        = string
}

variable "sub1_cidr" {
  description = "The CIDR block for the first public subnet"
  type        = string
}

variable "sub2_cidr" {
  description = "The CIDR block for the second public subnet"
  type        = string
}

variable "sub1_az" {
  description = "The AZ for the first public subnet"
  type        = string
}

variable "sub2_az" {
  description = "The AZ for the second public subnet"
  type        = string
}

variable "docker_image" {
  description = "The docker image to use for the ECS service"
  type        = string
}

variable "ecs_port" {
  description = "The TCP port on which the server will operate"
  type        = number
}

variable "ecs_cpu" {
  description = "CPU units for ECS tasks"
  type        = number
}

variable "ecs_mem" {
  description = "Memory units for ECS tasks"
  type        = number
}

variable "ecs_desired_tasks" {
  description = "The number of desired tasks to run for the webserver"
  type        = number
}
