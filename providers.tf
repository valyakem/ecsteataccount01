
terraform {
  required_providers {
      aws = {
        source =  "hashicorp/aws"
      } 
      random = {
	source = "hashicorp/random"
      }
      okta = {
      source  = "oktadeveloper/okta"
      version = ">= 2.6"
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