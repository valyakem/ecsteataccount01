data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = "okta_api_token"
}

provider "okta" {
  org_name  = var.org_name
  base_url  = var.base_url
  api_token = "${data.aws_secretsmanager_secret_version.secret_id}"
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