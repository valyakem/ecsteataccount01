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

resource "okta_user_schema" "example" {
  index       = "customPropertyName"
  title       = "customPropertyName"
  type        = "string"
  description = "My custom property name"
  master      = "OKTA"
  scope       = "SELF"
  user_type   = "${data.okta_user_type.example.id}"
}


