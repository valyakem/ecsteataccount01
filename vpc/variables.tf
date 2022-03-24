variable "name" {
  description = "the name of your stack, e.g. \"demo\""
  default     = "arcablanca-vpc"
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  default     = "prod"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
  default     = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
}

variable "private_subnets" {
  description = "List of private subnets"
  default     = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
}

variable "availability_zones" {
  description = "List of availability zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}


