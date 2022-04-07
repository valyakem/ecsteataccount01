//-----------Get Secrets from the secret manager --------------------//
resource "aws_secretsmanager_secret" "example" {
  name = "example"
}

resource "aws_secretsmanager_secret_policy" "example" {
  secret_arn = aws_secretsmanager_secret.example.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAnotherAWSAccountToReadTheSecret",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:root"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}


//-----------------------------------------------------------------------
//get the arn of the specific secret manager
data "aws_secretsmanager_secret" "arcablanca_secrets" {
  arn = "arn:aws:secretsmanager:us-east-1:440153443065:secret:okta_api-imYrkl"

  depends_on = []
}

//Get the current secret version
data "aws_secretsmanager_secret_version" "arcablanca_current" {
  secret_id = "${data.aws_secretsmanager_secret.arcablanca_secrets.id}"
}

//get tke keys and values as from the json file
data "external" "json" {
  program = ["echo", "${data.aws_secretsmanager_secret_version.arcablanca_current.secret_string}"]
}

//declare local variables and pass the values of the secrets 
locals {
  api_token = "${data.external.json.result.okta_api}"
  org_name = "${data.external.json.result.org_name}"
}
//----------------------------------------------------------------------------
//create okta provider
provider "okta" {
  org_name  = local.org_name
  base_url  = var.base_url
  api_token = local.api_token
}

//create a schema for okta group
resource "okta_group_schema_property" "nb_okta" {
  index       = "customPropertyName"
  title       = "customPropertyName"
  type        = "string"
  description = "My custom property name"
  master      = "OKTA"
  scope       = "SELF"
}

//create an o
resource "okta_group" "arca_bpt_group" {
  name        = "acarca-blancapt-group"
  description = "Arca Blanca Pricing Tool Group"
}


resource "okta_group_roles" "arca_bpt_group" {
  group_id    = "${okta_group.arca_bpt_group.id}"
  admin_roles = ["SUPER_ADMIN", "USER_ADMIN"]
}

resource "okta_user" "arca_blanca_user" {
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