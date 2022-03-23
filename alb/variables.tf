variable "name" {
  description = "the name of your stack, e.g. \"demo\""
  default     = "arcablanca" 
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  default     = "prod" 
}

variable "subnets" {
  description = "Comma separated list of subnet IDs"
  default     = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "alb_security_groups" {
  description = "Comma separated list of security groups"
}

variable "alb_tls_cert_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
}

variable "health_check_path" {
  description = "Path to check if the service is healthy, e.g. \"/status\""
}
