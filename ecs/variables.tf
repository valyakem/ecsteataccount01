variable "name" {
  description = "the name of your stack, e.g. \"demo\""
  default     = "arcablanca-ecs" 
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  default     = "prod" 
}

variable "region" {
  description = "the AWS region in which resources are created"
  default     = "us-east-1" 
}

variable "subnets" {
  description = "List of subnet IDs"
  default     = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
}

variable "ecs_service_security_groups" {
  description = "Comma separated list of security groups"
}

variable "container_port" {
  description = "Port of container"
  default     = 5000 
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  default     = 1024 
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default     = 512 
}

variable "container_image" {
  description = "Docker image to be launched"
  default = "440153443065.dkr.ecr.us-east-1.amazonaws.com/testecr"
}

variable "aws_alb_target_group_arn" {
  description = "ARN of the alb target group"
}

variable "service_desired_count" {
  description = "Number of services running in parallel"
  default     = 2 
}

variable "container_environment" {
  description = "The container environmnent variables"
  type        = list
}

# variable "container_secrets" {
#   description = "The container secret environmnent variables"
#   type        = list
# }

# variable "container_secrets_arns" {
#   description = "ARN for secrets"
# }
