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

resource "okta_group_schema_property" "nb_okta" {
  index       = "customPropertyName"
  title       = "customPropertyName"
  type        = "string"
  description = "My custom property name"
  master      = "OKTA"
  scope       = "SELF"
}

resource "okta_group" "usergroup" {
  name        = "nbUsers"
  description = "Okta users group"
}


resource "okta_group_roles" "grouprole" {
  group_id    = "${okta_group.usergroup.id}"
  admin_roles = ["SUPER_ADMIN", "USER_ADMIN"]
}

resource "okta_user" "example" {
  first_name         = "John"
  last_name          = "Smith"
  login              = "john.smith@nexgbits.com"
  email              = "john.smith@nexgbits.com"
  city               = "Toronto"
  cost_center        = "10"
  country_code       = "CA"
  department         = "IT"
  display_name       = "Dr. John Smith"
  division           = "Acquisitions"
  employee_number    = "111111"
  honorific_prefix   = "Dr."
  honorific_suffix   = "Jr."
  locale             = "en_CA"
  manager            = "Akem"
  manager_id         = "222222"
  middle_name        = "Valentine"
  mobile_phone       = "1112223333"
  nick_name          = "valy"
  organization       = "Nexgbits Inc."
  postal_address     = "1234 Testing St."
  preferred_language = "en-us"
  primary_phone      = "4445556666"
  profile_url        = "https://www.example.com/profile"
  second_email       = "john.smith.fun@example.com"
  state              = "NY"
  street_address     = "5678 Testing Ave."
  timezone           = "America/New_York"
  title              = "Director"
  user_type          = "Employee"
  zip_code           = "11111"
}





# output "test" {value = "${data.external.json.result.okta_api}"}
//okta additions