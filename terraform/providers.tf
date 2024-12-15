terraform {
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

terraform {
  backend "s3" {
    bucket = "bucket-for-tf1"
    key    = "tfBucket/terraform.tfstate"
    region = "ap-south-1"
  }
}
