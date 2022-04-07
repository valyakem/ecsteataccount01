data "aws_secretsmanager_secret" "secretmasterDB" {
  arn = aws_secretsmanager_secret.abpt_masterDB.arn

  depends_on = [aws_secretsmanager_secret.abpt_masterDB]
}
 
# Importing the AWS secret version created previously using arn.
data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.secretmasterDB.arn

  depends_on = [aws_secretsmanager_secret_version.abptrds_sversion]
}

//get tke keys and values as from the json file
data "external" "rdsjson" {
  program = ["echo", "${data.aws_secretsmanager_secret_version.creds.secret_string}"]
}
//-----------Get Secrets from the secret manager --------------------//
//-----------------------------------------------------------------------
//get the arn of the specific secret manager
data "aws_secretsmanager_secret" "arcablanca_secrets" {
  arn = "arn:aws:secretsmanager:us-east-1:440153443065:secret:okta_api-imYrkl"
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
  abpt-dbpwd = "${data.external.rdsjson.result.abpt-dbpwd}"
}