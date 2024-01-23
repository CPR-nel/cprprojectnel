terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# AWS Provider Configuration
provider "aws" {
  region  = var.region       # Set the AWS region using a variable
  profile = var.aws_profile  # Set the AWS profile using a variable
}
