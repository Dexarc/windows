terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
  access_key = "AKIAU2C4DWRWAX4MSC7M"
  secret_key = "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"
}

resource "aws_instance" "win" {
  ami           = "ami-0835374e611a23aa7"
  instance_type = "t2.micro"
  key_name = "oldec2"  
}