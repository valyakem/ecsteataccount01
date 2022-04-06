# variable "name" {
#   description = "the name of your stack, e.g. \"demo\""
# }
variable "okta_org_name" {
  default = ""
}

variable "okta_base_url" {
  default = "okta.com"
}

variable "okta_api_token" {
  default = ""
}


variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  default     = "prod"
}

# variable "region" {
#   description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
#   default     = "eu-central-1"
# }

# variable "aws-region" {
#   type        = string
#   description = "AWS region to launch servers."
#   default     = "eu-central-1"
# }

# variable "aws-access-key" {
#   type = string
# }

# variable "aws-secret-key" {
#   type = string
# }

# variable "application-secrets" {
#   description = "A map of secrets that is passed into the application. Formatted like ENV_VAR = VALUE"
#   type        = map
# }
variable "vpcname" {
description = "name of vpc"
default = "arcablanca-vpc"
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "a list of CIDRs for private subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
}

variable "public_subnets" {
  description = "a list of CIDRs for public subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
}

variable "alb_name" {
  default = "arcablanca-alb-prod"
}

variable "service_desired_count" {
  description = "Number of tasks running in parallel"
  default     = 2
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 5000
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  default     = 256
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default     = 512
}

variable "health_check_path" {
  description = "Http path for task health check"
  default     = "/health"
}

variable "tsl_certificate_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
  default = "arn:aws:acm:us-east-1:440153443065:certificate/16aee8f3-8f76-4a78-ba7b-fc0934bae6a1"
}

variable "repo_name" {
  description = "repository name"
  type    = string
  default = "testecr"
}

variable "branch_name" {
  description = "default commit branch"
  default = "main"
}

variable "build_project" {
  description = "codebuild project name"
  default = "dev-build-repo"
}

variable "uri_repo" {
  description = "uri repo information"
  default ="440153443065.dkr.ecr.us-east-1.amazonaws.com/testecr"
}

variable "ecr_name" {
  description = "Elastic container registry name"
  default     ="testecr"
}

variable "prodenvironment" {
  description = "Deployment environment name"
  default     ="prod"
}

variable "sg_name" {
  default = "arcablancapt-sg-alb-prod"
}

variable "ecs_name" {
  description = "Elastic Container Service Name"
  default     ="arcablanca-ecs"
}

variable "aws-region" {
  default = "us-east-1"
}

#=======================RDS VARIABLES========================
variable "rdsidentifier" {
  description                   = "A unique name given to our rds instance"
  default                       = "arcablanca-pt-rds" 
}

variable "instance_class" {
  description                   = "Chosen instance type for your database e.g., db.t3.micro, db.t2.micro etc"
  default                       = "db.t3.micro"
}


variable "terraform_pipeline" {
  description                   = "Name of pipeline"
  default                       = "arcablancapipeline" 
}

variable "auto_apply" {
  type        = bool
  default     = false
  description = "Whether to automatically apply changes when a Terraform plan is successful. Defaults to false."
}

variable "snsname" {
  description  = "Name of sns topic"
  default      = "arcablanca-auto-sns"
}



#-------------------------------------------------------------------------------------------------------------
#====================================