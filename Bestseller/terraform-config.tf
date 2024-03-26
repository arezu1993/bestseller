# Terraform Block
terraform {
  required_version = ">= 1.7" # which means any version equal & above 1.7 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  /*
  # It's recommended to set up the backend. since it wasn't in the assignment/task, I have commented it out.
  # Backend configuration for S3
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = "terraform_locks"
    encrypt        = true
  } 
 */
}
# Provider Block
provider "aws" {
  region = var.aws_region
}

/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal  
$HOME/.aws/credentials
*/