resource "okta_group" "example" {
  name        = "nexgbit-testapp"
  description = "Next Bit Test App Group"
}

resource "okta_group_membership" "example" {
  group_id = "${okta_group.example.id}"
  user_id  = "okta-dev-25336660"
}

resource "okta_user_schema" "dob_extension" {
  index  = "date_of_birth"
  title  = "Date of Birth"
  type   = "string"
  master = "PROFILE_MASTER"
}