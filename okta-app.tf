
terraform {
  required_providers {
    okta = {
      source = "okta/okta"
      version = "~> 3.20"
    }
  }
}


resource "okta_group" "example" {
  name        = "nexgbit-testapp"
  description = "Next Bit Test App Group"
}

resource "okta_idp_oidc" "example" {
  name                  = "example"
  authorization_url     = "https://dev-25336660.okta.com/oauth2/v1/authorize"
  authorization_binding = "HTTP-REDIRECT"
  token_url             = "https://idp.example.com/token"
  token_binding         = "HTTP-POST"
  user_info_url         = "https://idp.example.com/userinfo"
  user_info_binding     = "HTTP-REDIRECT"
  jwks_url              = "https://idp.example.com/keys"
  jwks_binding          = "HTTP-REDIRECT"
  scopes                = ["openid"]
  client_id             = "valentine.akem@nexgbits.com"
  client_secret         = "+Laravan2010"
  issuer_url            = "https://dev-25336660.okta.com/oauth2/default"
  username_template     = "idpuser.email"
}

resource "okta_group_membership" "example" {
  group_id = "${okta_group.example.id}"
  user_id  = "okta-dev-25336660"
}
