# VPC module for creating the Virtual Private Cloud on AWS
module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=e4768508a17f79337f9f1e48ebf47ee885b98c1f"

  # Setting up VPC parameters using variables
  name = "wordpress-project-vpc"
  cidr = "10.1.0.0/16"

  # Define availability zones and subnet types for the VPC
  azs              = ["eu-central-1a", "eu-central-1b"]
  private_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]
  public_subnets   = ["10.1.1.0/24", "10.1.2.0/24"]
  database_subnets = ["10.1.201.0/24", "10.1.202.0/24"]
  intra_subnets    = ["10.1.151.0/24", "10.1.152.0/24"]


  # Enable a database subnet group and NAT gateway for outbound traffic
  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true

  # Tagging subnets for identification and management
  tags = {
    Terraform = "true"
  }
}
