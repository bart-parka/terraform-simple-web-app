terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
#  profile = var.profile #Uncomment if running locally
  region  = var.region

  default_tags {
    tags = {
      Owner      = "Bart Parka",
      Deployment = "Terraform"
    }
  }
}