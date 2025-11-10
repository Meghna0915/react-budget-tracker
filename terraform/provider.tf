terraform {
  required_version = ">= 1.4.0"

  backend "s3" {
    bucket         = "your-s3-bucket-name"         # e.g. react-budget-tracker-tfstate
    key            = "terraform/state.tfstate"     # file path inside bucket
    region         = "ap-south-1"
    dynamodb_table = "your-dynamodb-table-name"    # e.g. terraform-lock-table
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
  region     = "ap-south-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
