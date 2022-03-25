# provider "aws" {
#   access_key = var.aws-access-key
#   secret_key = var.aws-secret-key
#   region     = var.aws-region
#   version    = "~> 2.0"
# }

# terraform {
#   backend "s3" {
#     bucket  = "terraform-backend-store"
#     encrypt = true
#     key     = "terraform.tfstate"
#     region  = "eu-central-1"
#     # dynamodb_table = "terraform-state-lock-dynamo" - uncomment this line once the terraform-state-lock-dynamo has been terraformed
#   }
# }

# resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
#   name           = "terraform-state-lock-dynamo"
#   hash_key       = "LockID"
#   read_capacity  = 20
#   write_capacity = 20
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
#   tags = {
#     Name = "DynamoDB Terraform State Lock Table"
#   }
# }

module "vpc" {
  source             = "./vpc"
  name               = var.vpcname
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "security_groups" {
  source         = "./security-groups"
  name           = var.sg_name
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = var.container_port
}

module "alb" {
  source              = "./alb"
  name                = var.alb_name
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  alb_security_groups = [module.security_groups.alb]
  alb_tls_cert_arn    = var.tsl_certificate_arn
  health_check_path   = var.health_check_path
}

module "ecr" {
  source      = "./ecr"
  name        = var.ecr_name
  environment = var.prodenvironment
}


# module "secrets" {
#   source              = "./secrets"
#   name                = var.name
#   environment         = var.environment
#   application-secrets = var.application-secrets
# }

module "ecs" {
  source                      = "./ecs"
  name                        = var.ecs_name
  environment                 = var.environment
  region                      = var.aws-region
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  service_desired_count       = var.service_desired_count
  container_environment = [
    { name = "LOG_LEVEL",
    value = "DEBUG" },
    { name = "PORT",
    value = var.container_port }
  ]
  ## container_secrets      = module.secrets.secrets_map
  ##aws_ecr_repository_url = module.ecr.aws_ecr_repository_url
  # container_secrets_arns = module.secrets.application_secrets_arn
}




#-------------------------------------------------------------------------------#
#=================================RDS MODULE====================================#
#-------------------------------------------------------------------------------#
