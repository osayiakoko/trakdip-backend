terraform {
  backend "s3" {
    bucket         = "trakdip-terraform-state-dev"
    key            = "tfstate/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "trakdip_terraform_locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Name        = "${var.project_name}-${var.environment}"
      Environment = var.environment
    }
  }
}
