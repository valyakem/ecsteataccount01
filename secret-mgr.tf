resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
 
# Creating a AWS secret for database master account (Arca-Blanca DB)
resource "aws_secretsmanager_secret" "abpt_masterDB" {
   name = "abpt-rds"
}
resource "aws_secretsmanager_secret_version" "abptrds_sversion" {
  secret_id = aws_secretsmanager_secret.abpt_masterDB.id
  secret_string = <<EOF
   {
    "abpt-dbadmin": "abpts-dbadmin",
    "abpt-dbpwd": "${random_password.password.result}"
   }
EOF
}

