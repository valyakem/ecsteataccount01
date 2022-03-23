variable "name" {
  description = "the name of your stack, e.g. \"demo\""
  default     = "arcablancapt" 
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  default     = "prod" 
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "container_port" {
  description = "Ingres and egress port of the container"
  default     = 5000 
}
