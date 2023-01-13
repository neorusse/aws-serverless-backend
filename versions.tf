variable "aws" {
  type = map
}

provider "aws" {
  region = var.aws["region"]
}

terraform {

  required_version = ">= 1.3.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }
  
  backend "s3" {
    bucket = "ecod-tf-backend"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "ecod-infra-tf-statelock"
  }
}