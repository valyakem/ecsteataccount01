
terraform {
  required_providers {
      aws = {
        source =  "hashicorp/aws"
      } 
      random = {
	source = "hashicorp/random"
      }
      okta = {
      source  = "okta/okta"
      version = "~> 3.18.0"
    }
}


backend "remote" {
organization = "Next-Generation-Business-IT-Solutions"
 
  
    workspaces {
      name = "modulestraining1"
    }
  }
}

# random providerss
provider "random" {}

## provider us-east-1
provider "aws" {
  region = "us-east-1"
}

provider "okta" {
  org_name  = var.org_name
  base_url  = var.base_url
  api_token = var.api_token
}