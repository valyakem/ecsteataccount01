data "aws_secretsmanager_secret" "by-arn" {
  arn = "arn:aws:secretsmanager:us-east-1:440153443065:secret:okta_api-imYrkl"
}

data "aws_secretsmanager_secret_version" "by-version-stage" {
  secret_id = "${data.aws_secretsmanager_secret.by-arn.id}"
}

data "external" "json" {
  program = ["echo", "${data.aws_secretsmanager_secret_version.by-version-stage.secret_string}"]
}


locals {
  api_token = "${data.external.json.result.okta_api}"
  org_name = "${data.external.json.result.org_name}"
}

provider "okta" {
  org_name  = local.org_name
  base_url  = var.base_url
  api_token = local.api_token
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

# output "test" {value = "${data.external.json.result.okta_api}"}
//okta additions