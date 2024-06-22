# Terraform block specifying the required providers and their versions
terraform {
  required_version = "1.6.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.55.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-wordpress-project"
    key            = "infrastructure-state/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-wordpress-project-locks"
    encrypt        = true
  }

}

# AWS provider configuration
provider "aws" {
  region = "eu-central-1"
}

