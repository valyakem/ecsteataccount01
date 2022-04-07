resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.secretmasterDB.id
  secret_string = <<EOF
   {
    "username": "adminaccount",
    "password": "${random_password.password.result}"
   }
EOF
}

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
  source                    = "./alb"
  name                      = var.alb_name
  vpc_id                    = module.vpc.id
  subnets                   = module.vpc.public_subnets
  environment               = var.environment
  alb_security_groups       = [module.security_groups.alb]
  alb_tls_cert_arn          = var.tsl_certificate_arn
  health_check_path         = var.health_check_path
}

module "ecr" {
  source      = "./ecr"
  name        = var.ecr_name
  environment = var.prodenvironment
}

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


#-------------------------- MODULE SECRET MANAGER ----------------------------#
module "secrets-manager-2" {

  #source = "lgallard/secrets-manager/aws"
  source = "./secret-mgr"

  secrets = {
    secret-kv-1 = {
      description = "This is a key/value secret"
      secret_key_value = {
        dbadmin = "abpt-adm"
        key2 = "${random_password.password.result}"
      }
      recovery_window_in_days = 7
      policy                  = <<POLICY
				{
					"Version": "2012-10-17",
					"Statement": [
						{
							"Sid": "EnableAllPermissions",
							"Effect": "Allow",
							"Principal": {
								"AWS": "*"
							},
							"Action": "secretsmanager:GetSecretValue",
							"Resource": "*"
						}
					]
				}
				POLICY
    },
    secret-kv-2 = {
      description = "Another key/value secret"
      secret_key_value = {
        okta_org_name = null
        okta_api_token = null
      }
      tags = {
        app = "web"
      }
      recovery_window_in_days = 7
      policy                  = null
    },
  }

  tags = {
    Owner       = "DevOps team"
    Environment = "dev"
    Terraform   = true
  }
}


module "secrets-manager-4" {
  #source = "lgallard/secrets-manager/aws"
  source = "./secret-mgr"

  rotate_secrets = {
    secret-rotate-1 = {
      description             = "This is a secret to be rotated by a lambda"
      secret_string           = "This is an example"
      rotation_lambda_arn     = "arn:aws:lambda:us-east-1:440153443065:function:lambda-rotate-secret"
      recovery_window_in_days = 15
    },
    secret-rotate-2 = {
      description             = "This is another secret to be rotated by a lambda"
      secret_string           = "This is another example"
      rotation_lambda_arn     = "arn:aws:lambda:us-east-1:440153443065:function:lambda-rotate-secret"
      recovery_window_in_days = 7
    },
  }

  tags = {
    Owner       = "DevOps team"
    Environment = "dev"
    Terraform   = true
  }

}

# Lambda to rotate secrets
# AWS temaplates available here https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas
module "rotate_secret_lambda" {
  source  = "./secret-mgr"

  filename         = "secrets_manager_rotation.zip"
  function_name    = "secrets-manager-rotation"
  handler          = "secrets_manager_rotation.lambda_handler"
  runtime          = "python3.7"
  source_code_hash = filebase64sha256("${path.module}/secrets_manager_rotation.zip")

  environment = {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.us-east-1.amazonaws.com"
    }
  }

}

resource "aws_lambda_permission" "allow_secret_manager_call_Lambda" {
  function_name = module.rotate_secret_lambda.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}
#----------------------
#-------------------------------------------------------------------------------#
#=================================RDS MODULE====================================#
#-------------------------------------------------------------------------------#
