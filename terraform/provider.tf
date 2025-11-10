terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "react-budget-tracker-tfstate"
    key            = "terraform/state"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
