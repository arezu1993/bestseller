# Terraform Block
terraform {
  required_version = ">= 1.7" # which means any version equal & above 1.7 
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.0"
    }
  } 
}  
# Provider Block
provider "aws" {
  region = var.aws_region
  
  
}
