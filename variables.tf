###-- Does not have defaults

variable "env" {
  description = "The environment for this deployment (eg, prod, staging, qa, dev, ...)"
  type        = string
}

variable "namespace" {
  description = "The namespace of this particular service (eg. webserver, database, etc.)"
  type        = string
}


###-- Has defaults

variable "aws_region" {
  description = "The AWS Region in which we're operating"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the primary VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr" {
  description = "The CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet2_cidr" {
  description = "The CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet1_az" {
  description = "The AZ for the first public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "subnet2_az" {
  description = "The AZ for the second public subnet"
  type        = string
  default     = "us-east-1b"
}

variable "ecs_image" {
  description = "The docker image to use for the ECS service"
  type        = string
  default     = "nginx:alpine"
}

variable "webserver_port" {
  description = "The port on which the webserver will operate"
  type        = number
  default     = 80
}

variable "cpu_units" {
  description = "The CPU units for each webserver ECS task"
  type        = number
  default     = 256
}

variable "mem_units" {
  description = "The memory units for each webserver ECS task"
  type        = number
  default     = 512
}

variable "desired_tasks" {
  description = "The number of desired webserver tasks"
  type        = number
  default     = 2
}
