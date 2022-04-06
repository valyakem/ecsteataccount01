data "aws_secretsmanager_secret" "secrets" {
  arn = "arn:aws:secretsmanager:us-east-1:440153443065:secret:okta_api_token-xWtQcE"
}

# data "aws_secretsmanager_secret_version" "current" {
#   secret_id = data.aws_secretsmanager_secret.secrets.arn
# }

locals {
  api_token = data.aws_secretsmanager_secret.secrets.arn
}

provider "okta" {
  org_name  = var.org_name
  base_url  = var.base_url
  api_token = "${local.api_token}"
}

resource "okta_group_schema_property" "example" {
  index       = "customPropertyName"
  title       = "customPropertyName"
  type        = "string"
  description = "My custom property name"
  master      = "OKTA"
  scope       = "SELF"
}


resource "okta_user_type" "example" {
  name   = "example"
  display_name = "example"
  description = "example"
}

resource "okta_user_schema_property" "example" {
  index       = "customPropertyName"
  title       = "customPropertyName"
  type        = "string"
  description = "My custom property name"
  master      = "OKTA"
  scope       = "SELF"
  user_type   = "${okta_user_type.example.id}"
}


//okta additions