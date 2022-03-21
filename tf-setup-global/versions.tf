terraform {
  backend "s3" {
    bucket = "terraform-safe"
    key = "./terraform.tfstate"
    region = "sa-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}