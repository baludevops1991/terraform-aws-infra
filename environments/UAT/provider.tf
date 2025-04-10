terraform {
  required_version = "1.11.3" # Specifies the required Terraform version; ensures consistent behavior across environments
  required_providers {
    aws = {
      version = "~> 4.65" # Specifies the required AWS provider version to maintain compatibility
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region # Configures the AWS provider with the specified region
  #profile = var.aws_profile
}