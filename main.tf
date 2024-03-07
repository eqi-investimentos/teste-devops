terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.59.0"
    }
  }

}

provider "aws" {
  region = var.aws_region

  default_tags {

    tags = local.common_tags
  }
}