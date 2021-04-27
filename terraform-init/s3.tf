terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "moikilo00-tfstate-bucket" {
  bucket = "moikilo00-tfstate-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "line-bot-sample2/tfstate"
    Environment = "Dev"
  }
}
