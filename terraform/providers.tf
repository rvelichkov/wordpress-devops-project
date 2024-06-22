# Terraform block specifying the required providers and their versions
terraform {
  required_version = "1.6.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.55.0"
    }
  }
}

# AWS provider configuration
provider "aws" {
  region = "eu-central-1"
}

