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

module "security_groups" {
  source  = "./security_groups"

  name        = local.name
  description = "Complete PostgreSQL example security group"
  vpc_id      = module.vpc.id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}

################################################################################
# RDS Module
################################################################################

#==========================DB INSTANCE CODES======================
#-------------------------------------------------------------------
resource "aws_db_instance" "arcablanca_pt_rds" {
  identifier                    = "${var.rdsidentifier}"
  instance_class                = "${var.instance_class}"
  allocated_storage             = 5
  max_allocated_storage         = 100
  engine                        = "postgres"
  engine_version                = "10"
  username                      = "arcablancausr"
  password                      = var.db_password
  db_subnet_group_name          = module.vpc.private_subnets
  vpc_security_group_ids        = [aws_security_group.arcablanca_rds_sg.id]
  parameter_group_name          = "${var.parameter_group_name}"
  publicly_accessible           = false
  skip_final_snapshot           = true
  auto_minor_version_upgrade    = false
  backup_window                 = "01:00-01:30" 
}

#==========================DB SUBNET GROUP======================
#-------------------------------------------------------------------
resource "aws_db_subnet_group" "arcablanca_pt_dbsubnets" {
  name       = "main"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "Arca-Blanca-PT-dbSubnet-Group"
  }
}

#==========================PARAMETER  RDS SG======================
#-------------------------------------------------------------------

resource "aws_security_group" "arcablanca_rds_sg" {
  name                          = "abpt_web_sg"
  description                   = "Allow traffic for arcablanca web apps"
  vpc_id                        =  aws_vpc.vpc.id

  ingress {
      from_port         = 5432
      to_port           = 5432
      protocol          = "tcp"
      security_groups   = module.alb.id
  }  
  ingress {
      from_port         = 5433
      to_port           = 5433
      protocol          = "tcp"
      security_groups = module.alb.id
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


#==========================PARAMETER  GROUPs======================
#-------------------------------------------------------------------
resource "aws_db_parameter_group" "arcablanca-pt-rds" {
  name   = "${var.parameter_group_name}"
  family = "postgres10"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}


#==========================DB CREDENTIALSC======================
#-------------------------------------------------------------------
variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
  default = "+Laravan2010"
}

variable "parameter_group_name" {
  description           = "Parameter group name" 
  default               = "arcablancaptrds"
}


#==========================DB OUTPUT======================
#-------------------------------------------------------------------
output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.arcablanca_pt_rds.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.arcablanca_pt_rds.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.arcablanca_pt_rds.username
  sensitive   = true
}

